import React, { useState } from 'react';
import { View, StyleSheet, Alert } from 'react-native';
import { TextInput, Button } from 'react-native-paper';
import axiosInstance from '../base_axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { ScreenNavigationProp } from '../types';

interface AddHabitScreenProps {
  navigation: ScreenNavigationProp;
}

const AddHabitScreen: React.FC<AddHabitScreenProps> = ({ navigation }) => {
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
      navigation.goBack();
    } catch (error) {
      console.error('Failed to add habit:', error);
      Alert.alert('Error', 'Failed to add habit');
    }
  };

  return (
    <View style={styles.container}>
      <TextInput
        label="Habit Name"
        value={habitName}
        onChangeText={setHabitName}
        style={styles.input}
      />
      <TextInput
        label="Time/Location"
        value={timeLocation}
        onChangeText={setTimeLocation}
        style={styles.input}
      />
      <TextInput
        label="Identity"
        value={identity}
        onChangeText={setIdentity}
        style={styles.input}
      />
      <Button mode="contained" onPress={handleAddHabit} style={styles.button}>
        Add Habit
      </Button>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  input: {
    marginBottom: 12,
  },
  button: {
    marginTop: 16,
  },
});

export default AddHabitScreen;
