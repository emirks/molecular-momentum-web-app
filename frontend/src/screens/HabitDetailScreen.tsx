import React, { useEffect, useState } from 'react';
import { View, Text, Button, StyleSheet, Alert } from 'react-native';
import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';

const HabitDetailScreen = ({ route }) => {
  const { habitId } = route.params;
  const [habit, setHabit] = useState(null);

  useEffect(() => {
    fetchHabitDetails();
  }, []);

  const fetchHabitDetails = async () => {
    try {
      const token = await AsyncStorage.getItem('token');
      const response = await axios.get(`http://10.0.2.2:8000/api/habits/${habitId}/detailed/`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setHabit(response.data);
    } catch (error) {
      console.error('Failed to fetch habit details:', error);
      Alert.alert('Error', 'Failed to fetch habit details');
    }
  };

  const markCompleted = async () => {
    try {
      const token = await AsyncStorage.getItem('token');
      await axios.post(`http://10.0.2.2:8000/api/habits/${habitId}/mark-completed/`, {}, {
        headers: { Authorization: `Bearer ${token}` }
      });
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
      <Text>Current Streak: {habit.streak?.current_streak}</Text>
      <Text>Longest Streak: {habit.streak?.longest_streak}</Text>
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
