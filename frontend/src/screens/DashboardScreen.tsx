import React, { useEffect, useState } from 'react';
import { View, FlatList, StyleSheet, Button, Alert } from 'react-native';
import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import HabitItem from '../components/HabitItem';

const DashboardScreen = ({ navigation }) => {
  const [habits, setHabits] = useState([]);

  useEffect(() => {
    fetchHabits();
  }, []);

  const fetchHabits = async () => {
    try {
      const token = await AsyncStorage.getItem('token');
      const userId = await AsyncStorage.getItem('userId'); // Assuming you store the user's ID at login
      if (!userId) {
        throw new Error('User ID not found');
      }
      const response = await axios.get(`http://10.0.2.2:8000/api/users/${userId}/habits/`, {
        headers: { Authorization: `Bearer ${token}` }
      });
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
