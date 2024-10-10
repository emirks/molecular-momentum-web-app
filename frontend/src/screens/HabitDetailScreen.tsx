import React, { useEffect, useState } from 'react';
import { View, Text, Button, StyleSheet } from 'react-native';
import axios from 'axios';

const HabitDetailScreen = ({ route }) => {
  const { habitId } = route.params;
  const [habit, setHabit] = useState(null);

  useEffect(() => {
    fetchHabitDetails();
  }, []);

  const fetchHabitDetails = async () => {
    try {
      const response = await axios.get(`http://localhost:8000/habits/${habitId}/detailed/`);
      setHabit(response.data);
    } catch (error) {
      console.error('Failed to fetch habit details:', error);
    }
  };

  const markCompleted = async () => {
    try {
      await axios.post(`http://localhost:8000/habits/${habitId}/mark-completed/`);
      fetchHabitDetails(); // Refresh habit details
    } catch (error) {
      console.error('Failed to mark habit as completed:', error);
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
