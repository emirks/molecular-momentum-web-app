import React from 'react';
import { TouchableOpacity, Text, StyleSheet } from 'react-native';
import { Habit } from '../types';

interface HabitItemProps {
  habit: Habit;
  onPress: () => void;
}

const HabitItem: React.FC<HabitItemProps> = ({ habit, onPress }) => {
  return (
    <TouchableOpacity style={styles.container} onPress={onPress}>
      <Text style={styles.title}>{habit.habit_name}</Text>
      <Text>{habit.time_location}</Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
  },
});

export default HabitItem;
