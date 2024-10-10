from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import (
    UserViewSet,
    TrackingChannelViewSet,
    HabitViewSet,
    HabitCompletionViewSet,
    HabitStreakViewSet
)

router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'channels', TrackingChannelViewSet, basename='trackingchannel')
router.register(r'habits', HabitViewSet)
router.register(r'completions', HabitCompletionViewSet)
router.register(r'streaks', HabitStreakViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('habits/<uuid:pk>/mark-completed/', HabitViewSet.as_view({'post': 'mark_completed'}), name='habit-mark-completed'),
    path('habits/<uuid:pk>/detailed/', HabitViewSet.as_view({'get': 'detailed'}), name='habit-detailed'),
]

# Additional custom endpoints
urlpatterns += [
    path('users/<uuid:pk>/habits/', UserViewSet.as_view({'get': 'habits'}), name='user-habits'),
    path('channels/<uuid:pk>/detailed/', TrackingChannelViewSet.as_view({'get': 'detailed'}), name='channel-detailed'),
    path('channels/<uuid:pk>/add-user/', TrackingChannelViewSet.as_view({'post': 'add_user'}), name='channel-add-user'),
    path('habits/<uuid:pk>/detailed/', HabitViewSet.as_view({'get': 'detailed'}), name='habit-detailed'),
    path('streaks/reset/', HabitStreakViewSet.as_view({'post': 'reset_streak'}), name='streak-reset'),
]