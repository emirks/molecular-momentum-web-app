import React, { useEffect, useState } from 'react';
import { View, FlatList, StyleSheet } from 'react-native';
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
      const response = await axios.get('http://localhost:8000/api/habits/', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setHabits(response.data);
    } catch (error) {
      console.error('Failed to fetch habits:', error);
    }
  };

  return (
    <View style={styles.container}>
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
