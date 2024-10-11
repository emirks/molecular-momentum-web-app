import React, { useEffect, useState } from 'react';
import { View, StyleSheet, Alert } from 'react-native';
import { Text, Button, Card, Title, Paragraph } from 'react-native-paper';
import axiosInstance from '../base_axios';
import { ScreenNavigationProp, Habit } from '../types';
import { RouteProp } from '@react-navigation/native';

type HabitDetailScreenRouteProp = RouteProp<RootStackParamList, 'HabitDetail'>;

interface HabitDetailScreenProps {
  route: HabitDetailScreenRouteProp;
  navigation: ScreenNavigationProp;
}

const HabitDetailScreen: React.FC<HabitDetailScreenProps> = ({ route }) => {
  const { habitId } = route.params;
  const [habit, setHabit] = useState<Habit | null>(null);

  useEffect(() => {
    fetchHabitDetails();
  }, []);

  const fetchHabitDetails = async () => {
    try {
      const response = await axiosInstance.get(`habits/${habitId}/detailed/`);
      console.log('Habit details:', response.data);
      setHabit(response.data);
    } catch (error) {
      console.error('Failed to fetch habit details:', error);
      Alert.alert('Error', 'Failed to fetch habit details');
    }
  };

  const markCompleted = async () => {
    try {
      await axiosInstance.post(`habits/${habitId}/mark-completed/`);
      fetchHabitDetails();
      Alert.alert('Success', 'Habit marked as completed');
    } catch (error) {
      console.error('Failed to mark habit as completed:', error);
      Alert.alert('Error', 'Failed to mark habit as completed');
    }
  };

  if (!habit) {
    return <Text>Loading...</Text>;
  }

  return (
    <View style={styles.container}>
      <Card>
        <Card.Content>
          <Title>{habit.habit_name}</Title>
          <Paragraph>Time/Location: {habit.time_location}</Paragraph>
          <Paragraph>Identity: {habit.identity}</Paragraph>
          <Paragraph>Current Streak: {habit.streak ? habit.streak.current_streak : 'N/A'}</Paragraph>
          <Paragraph>Longest Streak: {habit.streak ? habit.streak.longest_streak : 'N/A'}</Paragraph>
        </Card.Content>
        <Card.Actions>
          <Button onPress={markCompleted}>Mark as Completed</Button>
        </Card.Actions>
      </Card>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
});

export default HabitDetailScreen;