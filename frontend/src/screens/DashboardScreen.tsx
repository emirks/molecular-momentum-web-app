import React, { useEffect, useState } from 'react';
import { View, FlatList, StyleSheet, Button, Alert } from 'react-native';
import axiosInstance from '../base_axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import HabitItem from '../components/HabitItem';

const DashboardScreen = ({ navigation }) => {
  const [habits, setHabits] = useState([]);

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
      <Button title="Add New Habit" onPress={handleAddHabit} />
      <FlatList
        data={habits}
        renderItem={({ item }) => (
          <HabitItem
            habit={item}
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
});

export default DashboardScreen;
