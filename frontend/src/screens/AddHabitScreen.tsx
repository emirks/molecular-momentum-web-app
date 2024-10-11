import React, { useState } from 'react';
import { View, TextInput, Button, StyleSheet, Alert } from 'react-native';
import axiosInstance from '../base_axios';
import AsyncStorage from '@react-native-async-storage/async-storage';

const AddHabitScreen = ({ navigation }) => {
  const [habitName, setHabitName] = useState('');
  const [timeLocation, setTimeLocation] = useState('');
  const [identity, setIdentity] = useState('');

  const handleAddHabit = async () => {
    try {
      const userId = await AsyncStorage.getItem('userId');
      if (!userId) {
        throw new Error('User ID not found');
      }

      const response = await axiosInstance.post('habits/', {
        user: userId,
        habit_name: habitName,
        time_location: timeLocation,
        identity: identity,
      });

      Alert.alert('Success', 'Habit added successfully');
      navigation.goBack(); // Return to the Dashboard
    } catch (error) {
      console.error('Failed to add habit:', error);
      Alert.alert('Error', 'Failed to add habit');
    }
  };

  return (
    <View style={styles.container}>
      <TextInput
        style={styles.input}
        placeholder="Habit Name"
        value={habitName}
        onChangeText={setHabitName}
      />
      <TextInput
        style={styles.input}
        placeholder="Time/Location"
        value={timeLocation}
        onChangeText={setTimeLocation}
      />
      <TextInput
        style={styles.input}
        placeholder="Identity"
        value={identity}
        onChangeText={setIdentity}
      />
      <Button title="Add Habit" onPress={handleAddHabit} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  input: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    marginBottom: 12,
    paddingLeft: 8,
  },
});

export default AddHabitScreen;
