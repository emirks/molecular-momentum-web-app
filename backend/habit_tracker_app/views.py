import logging

logger = logging.getLogger(__name__)

from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from django.shortcuts import get_object_or_404
from django.utils import timezone
from .models import User, TrackingChannel, Habit, HabitCompletion, HabitStreak
from .serializers import (
    UserSerializer, TrackingChannelSerializer, HabitSerializer, 
    HabitCompletionSerializer, HabitStreakSerializer, 
    DetailedHabitSerializer, DetailedTrackingChannelSerializer
)

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

    def get_permissions(self):
        if self.action == 'create':
            return [AllowAny()]
        return super().get_permissions()

    def list(self, request):
        logger.info(f"User {request.user.username} retrieved user list")
        return super().list(request)

    def retrieve(self, request, pk=None):
        logger.info(f"User {request.user.username} retrieved user details for user {pk}")
        return super().retrieve(request, pk)

    @action(detail=True, methods=['get'])
    def habits(self, request, pk=None):
        user = self.get_object()
        habits = Habit.objects.filter(user=user)
        serializer = HabitSerializer(habits, many=True)
        logger.info(f"User {request.user.username} retrieved habits for user {pk}")
        return Response(serializer.data)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        user.set_password(request.data['password'])
        user.save()
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

class TrackingChannelViewSet(viewsets.ModelViewSet):
    queryset = TrackingChannel.objects.all()
    serializer_class = TrackingChannelSerializer
    permission_classes = [IsAuthenticated]

    def list(self, request):
        logger.info(f"User {request.user.username} retrieved tracking channel list")
        return super().list(request)

    def retrieve(self, request, pk=None):
        logger.info(f"User {request.user.username} retrieved tracking channel details for channel {pk}")
        return super().retrieve(request, pk)

    @action(detail=True, methods=['get'])
    def detailed(self, request, pk=None):
        channel = self.get_object()
        serializer = DetailedTrackingChannelSerializer(channel)
        logger.info(f"User {request.user.username} retrieved detailed view of tracking channel {pk}")
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def add_user(self, request, pk=None):
        channel = self.get_object()
        user_id = request.data.get('user_id')
        user = get_object_or_404(User, id=user_id)
        
        if channel.users.count() >= 8:
            logger.warning(f"User {request.user.username} attempted to add user {user_id} to full channel {pk}")
            return Response({"error": "Channel is already full"}, status=status.HTTP_400_BAD_REQUEST)
        
        channel.users.add(user)
        logger.info(f"User {request.user.username} added user {user_id} to channel {pk}")
        return Response({"success": f"User {user.username} added to channel {channel.name}"})

class HabitViewSet(viewsets.ModelViewSet):
    queryset = Habit.objects.all()
    serializer_class = HabitSerializer
    permission_classes = [IsAuthenticated]

    def list(self, request):
        logger.info(f"User {request.user.username} retrieved habit list")
        return super().list(request)

    def retrieve(self, request, pk=None):
        logger.info(f"User {request.user.username} retrieved habit details for habit {pk}")
        return super().retrieve(request, pk)

    @action(detail=True, methods=['get'])
    def detailed(self, request, pk=None):
        habit = self.get_object()
        serializer = DetailedHabitSerializer(habit)
        logger.info(f"User {request.user.username} retrieved detailed view of habit {pk}")
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def mark_completed(self, request, pk=None):
        habit = self.get_object()
        completion = HabitCompletion.objects.create(habit=habit)
        
        streak, created = HabitStreak.objects.get_or_create(habit=habit)
        streak.current_streak += 1
        streak.longest_streak = max(streak.longest_streak, streak.current_streak)
        streak.last_completed = timezone.now()
        streak.save()
        
        logger.info(f"User {request.user.username} marked habit {pk} as completed. Current streak: {streak.current_streak}")
        return Response({'status': 'habit marked as completed'})

class HabitCompletionViewSet(viewsets.ModelViewSet):
    queryset = HabitCompletion.objects.all()
    serializer_class = HabitCompletionSerializer
    permission_classes = [IsAuthenticated]

    def list(self, request):
        logger.info(f"User {request.user.username} retrieved habit completion list")
        return super().list(request)

    def retrieve(self, request, pk=None):
        logger.info(f"User {request.user.username} retrieved habit completion details for completion {pk}")
        return super().retrieve(request, pk)

class HabitStreakViewSet(viewsets.ModelViewSet):
    queryset = HabitStreak.objects.all()
    serializer_class = HabitStreakSerializer
    permission_classes = [IsAuthenticated]

    def list(self, request):
        logger.info(f"User {request.user.username} retrieved habit streak list")
        return super().list(request)

    def retrieve(self, request, pk=None):
        logger.info(f"User {request.user.username} retrieved habit streak details for streak {pk}")
        return super().retrieve(request, pk)

    @action(detail=False, methods=['post'])
    def reset_streak(self, request):
        habit_id = request.data.get('habit_id')
        habit = get_object_or_404(Habit, id=habit_id)
        
        streak, created = HabitStreak.objects.get_or_create(habit=habit)
        streak.current_streak = 0
        streak.save()

        logger.info(f"User {request.user.username} reset streak for habit {habit_id}")
        serializer = self.get_serializer(streak)
        return Response(serializer.data)