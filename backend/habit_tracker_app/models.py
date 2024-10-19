import uuid
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone

class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    # username and password fields are already included from AbstractUser
    # Add any additional fields you need

    class Meta:
        db_table = 'users'

class TrackingChannel(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255, null=True, blank=True)
    users = models.ManyToManyField(User, related_name='tracking_channels')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Tracking Channel {self.id}: {self.name}"

    class Meta:
        db_table = 'tracking_channels'

class Habit(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='habits')
    tracking_channel = models.ForeignKey(TrackingChannel, on_delete=models.SET_NULL, null=True, related_name='habits')
    habit_name = models.CharField(max_length=255)
    time_location = models.CharField(max_length=255, null=True, blank=True)
    identity = models.CharField(max_length=255, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username}'s habit: {self.habit_name}"

    class Meta:
        db_table = 'habits'

class HabitCompletion(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    habit = models.ForeignKey(Habit, on_delete=models.CASCADE, related_name='completions')
    completed_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'habit_completions'

class HabitStreak(models.Model):
    id = models.BigAutoField(primary_key=True)
    habit = models.OneToOneField(Habit, on_delete=models.CASCADE, related_name='streak')
    current_streak = models.IntegerField(default=0)
    longest_streak = models.IntegerField(default=0)
    last_completed = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"{self.habit.habit_name} - Current Streak: {self.current_streak}, Longest: {self.longest_streak}"

    class Meta:
        db_table = 'habit_streaks'
