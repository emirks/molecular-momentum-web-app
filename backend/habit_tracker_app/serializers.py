from rest_framework import serializers
from .models import User, TrackingChannel, Habit, HabitCompletion, HabitStreak
from django.contrib.auth.password_validation import validate_password

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        if password:
            validate_password(password)
            instance.set_password(password)
        instance.save()
        return instance

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
