from rest_framework import serializers
from .models import User, TrackingChannel, Habit, HabitCompletion, HabitStreak

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']  # Add any other fields you want to include, but remove 'created_at' if it's not in your User model

class TrackingChannelSerializer(serializers.ModelSerializer):
    class Meta:
        model = TrackingChannel
        fields = ['id', 'name', 'users', 'created_at']
        read_only_fields = ['id', 'created_at']

    def create(self, validated_data):
        users = validated_data.pop('users', [])
        channel = TrackingChannel.objects.create(**validated_data)
        channel.users.set(users)
        return channel

class HabitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Habit
        fields = ['id', 'user', 'tracking_channel', 'habit_name', 'time_location', 'identity', 'created_at']

class HabitCompletionSerializer(serializers.ModelSerializer):
    class Meta:
        model = HabitCompletion
        fields = ['id', 'habit', 'completed_at']

class HabitStreakSerializer(serializers.ModelSerializer):
    class Meta:
        model = HabitStreak
        fields = ['id', 'habit', 'current_streak', 'longest_streak', 'last_completed']

class DetailedHabitSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    tracking_channel = TrackingChannelSerializer(read_only=True)
    completions = HabitCompletionSerializer(many=True, read_only=True)
    streak = HabitStreakSerializer(read_only=True)

    class Meta:
        model = Habit
        fields = ['id', 'user', 'tracking_channel', 'habit_name', 'time_location', 'identity', 'created_at', 'completions', 'streak']

class DetailedTrackingChannelSerializer(serializers.ModelSerializer):
    users = UserSerializer(many=True, read_only=True)
    habits = HabitSerializer(many=True, read_only=True)

    class Meta:
        model = TrackingChannel
        fields = ['id', 'name', 'users', 'habits', 'created_at']