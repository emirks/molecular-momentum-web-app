import React, { useEffect, useState } from 'react';
import { View, FlatList, StyleSheet, Alert } from 'react-native';
import { Button, List } from 'react-native-paper';
import axiosInstance from '../base_axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { ScreenNavigationProp, Habit } from '../types';

interface DashboardScreenProps {
  navigation: ScreenNavigationProp;
}

const DashboardScreen: React.FC<DashboardScreenProps> = ({ navigation }) => {
  const [habits, setHabits] = useState<Habit[]>([]);

  useEffect(() => {
    fetchHabits();
  }, []);

  const fetchHabits = async () => {
    try {
      const userId = await AsyncStorage.getItem('userId');
      if (!userId) {
        throw new Error('User ID not found');
      }
      const response = await axiosInstance.get(`/users/${userId}/habits/`);
      setHabits(response.data);
    } catch (error) {
      console.error('Failed to fetch habits:', error);
      Alert.alert('Error', 'Failed to fetch habits');
    }
  };

  const handleAddHabit = () => {
    navigation.navigate('AddHabit');
  };

  return (
    <View style={styles.container}>
      <Button mode="contained" onPress={handleAddHabit} style={styles.button}>
        Add New Habit
      </Button>
      <FlatList
        data={habits}
        renderItem={({ item }) => (
          <List.Item
            title={item.habit_name}
            description={item.time_location}
            onPress={() => navigation.navigate('HabitDetail', { habitId: item.id })}
          />
        )}
        keyExtractor={(item) => item.id}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  button: {
    marginBottom: 16,
  },
});

export default DashboardScreen;
