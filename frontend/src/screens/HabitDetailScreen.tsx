import React, { useEffect, useState } from 'react';
import { View, Text, Button, StyleSheet, Alert } from 'react-native';
import axiosInstance from '../base_axios';

const HabitDetailScreen = ({ route }) => {
  const { habitId } = route.params;
  const [habit, setHabit] = useState(null);

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
      fetchHabitDetails(); // Refresh habit details
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
      <Text style={styles.title}>{habit.habit_name}</Text>
      <Text>Time/Location: {habit.time_location}</Text>
      <Text>Identity: {habit.identity}</Text>
      <Text>Current Streak: {habit.streak ? habit.streak.current_streak : 'N/A'}</Text>
      <Text>Longest Streak: {habit.streak ? habit.streak.longest_streak : 'N/A'}</Text>
      <Button title="Mark as Completed" onPress={markCompleted} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
  },
});

export default HabitDetailScreen;