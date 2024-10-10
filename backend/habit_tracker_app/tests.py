from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from .models import User, TrackingChannel, Habit, HabitCompletion, HabitStreak
from rest_framework_simplejwt.tokens import RefreshToken

class HabitTrackerTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(username='testuser', password='testpass123')
        self.token = str(RefreshToken.for_user(self.user).access_token)
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {self.token}')

    def test_create_habit(self):
        url = reverse('habit-list')
        data = {
            'habit_name': 'Test Habit',
            'time_location': 'Morning',
            'identity': 'Healthy Person',
            'user': self.user.id  # Add this line
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Habit.objects.count(), 1)
        self.assertEqual(Habit.objects.get().habit_name, 'Test Habit')

    def test_get_user_habits(self):
        Habit.objects.create(user=self.user, habit_name='Existing Habit')
        url = reverse('user-habits', kwargs={'pk': self.user.id})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['habit_name'], 'Existing Habit')

    def test_mark_habit_completed(self):
        habit = Habit.objects.create(user=self.user, habit_name='Habit to Complete')
        url = reverse('habit-mark-completed', kwargs={'pk': habit.id})
        response = self.client.post(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(HabitCompletion.objects.count(), 1)
        self.assertEqual(HabitStreak.objects.get(habit=habit).current_streak, 1)

    def test_get_detailed_habit(self):
        habit = Habit.objects.create(
            user=self.user,
            habit_name='Detailed Habit',
            time_location='Morning',
            identity='Healthy Person'
        )
        HabitCompletion.objects.create(habit=habit)
        HabitStreak.objects.create(habit=habit, current_streak=1, longest_streak=1)
        url = reverse('habit-detailed', kwargs={'pk': habit.id})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['habit_name'], 'Detailed Habit')
        self.assertEqual(len(response.data['completions']), 1)
        self.assertEqual(response.data['streak']['current_streak'], 1)

    def test_unauthorized_access(self):
        self.client.credentials()  # Clear credentials
        url = reverse('habit-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_create_tracking_channel(self):
        url = reverse('trackingchannel-list')
        data = {'name': 'Test Channel', 'users': [self.user.id]}
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(TrackingChannel.objects.count(), 1)
        self.assertEqual(TrackingChannel.objects.get().name, 'Test Channel')

    def test_add_user_to_channel(self):
        channel = TrackingChannel.objects.create(name='Channel to Join')
        url = reverse('channel-add-user', kwargs={'pk': channel.id})
        data = {'user_id': str(self.user.id)}
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(channel.users.filter(id=self.user.id).exists())
