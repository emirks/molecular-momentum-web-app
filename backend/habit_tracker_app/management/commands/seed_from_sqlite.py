import sqlite3
import uuid
from django.core.management.base import BaseCommand
from django.utils import timezone
from habit_tracker_app.models import User, TrackingChannel, Habit, HabitCompletion, HabitStreak
from django.contrib.auth.hashers import make_password

class Command(BaseCommand):
    help = 'Seed data from existing SQLite database'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('Command recognized and running'))
        
        # Connect to the SQLite database
        conn = sqlite3.connect('database.db')
        cursor = conn.cursor()

        # Seed Users
        cursor.execute("SELECT * FROM users")
        for row in cursor.fetchall():
            User.objects.get_or_create(
                id=row[0],
                defaults={
                    'username': row[1] or str(row[0]),
                    'password': make_password('defaultpassword')  # Set a default password
                }
            )

        # Seed TrackingChannel and add users
        cursor.execute("SELECT * FROM tracking_channels")
        for row in cursor.fetchall():
            channel, _ = TrackingChannel.objects.get_or_create(
                id=row[0],
                defaults={'name': f'Channel {row[0]}'}
            )
            for user_id in row[1:]:
                if user_id:
                    user = User.objects.get(id=user_id)
                    channel.users.add(user)

        # Seed Habit
        cursor.execute("SELECT * FROM habits")
        for row in cursor.fetchall():
            user = User.objects.get(id=row[1])
            channel = TrackingChannel.objects.filter(id=row[2]).first()
            Habit.objects.get_or_create(
                id=row[0],
                defaults={
                    'user': user,
                    'tracking_channel': channel,
                    'habit_name': row[3],
                    'time_location': row[4],
                    'identity': row[5]
                }
            )

        # Seed HabitCompletion and HabitStreak
        cursor.execute("SELECT * FROM tracking")
        for row in cursor.fetchall():
            habit = Habit.objects.filter(id=row[0]).first()
            if habit:
                week_key = row[1]
                completed = bool(row[2])
                streak = row[3]

                if completed:
                    HabitCompletion.objects.get_or_create(
                        habit=habit,
                        completed_at=timezone.now()  # You might want to derive this from week_key
                    )

                habit_streak, created = HabitStreak.objects.get_or_create(habit=habit)
                habit_streak.current_streak = streak
                habit_streak.longest_streak = max(habit_streak.longest_streak, streak)
                habit_streak.last_completed = timezone.now() if completed else None
                habit_streak.save()

        conn.close()
        self.stdout.write(self.style.SUCCESS('Successfully seeded data from SQLite database'))
