import { StackNavigationProp } from '@react-navigation/stack';

export interface Habit {
  id: string;
  habit_name: string;
  time_location: string;
  identity: string;
  streak?: {
    current_streak: number;
    longest_streak: number;
  };
}

export type RootStackParamList = {
  Login: undefined;
  Registration: undefined;
  Dashboard: undefined;
  HabitDetail: { habitId: string };
  AddHabit: undefined;
};

export type ScreenNavigationProp = StackNavigationProp<RootStackParamList>;
