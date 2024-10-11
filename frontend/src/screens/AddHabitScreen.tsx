import React, { useState } from 'react';
import { View, StyleSheet, Alert, ScrollView } from 'react-native';
import { TextInput, Button, Text } from 'react-native-paper';
import axiosInstance from '../base_axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { ScreenNavigationProp } from '../types';
import LinearGradient from 'react-native-linear-gradient';
import { SafeAreaView } from 'react-native-safe-area-context';
import Icon from 'react-native-vector-icons/Ionicons';

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
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <LinearGradient
          colors={['#FF69B4', '#FF8C00', '#FFA500']}
          style={styles.gradient}
        >
          <View style={styles.header}>
            <Text style={styles.headerText}>Add New Habit</Text>
          </View>
        </LinearGradient>
        <View style={styles.formContainer}>
          <TextInput
            label="Habit Name"
            value={habitName}
            onChangeText={setHabitName}
            style={styles.input}
            left={<TextInput.Icon icon="pencil" />}
          />
          <TextInput
            label="Time/Location"
            value={timeLocation}
            onChangeText={setTimeLocation}
            style={styles.input}
            left={<TextInput.Icon icon="clock-outline" />}
          />
          <TextInput
            label="Identity"
            value={identity}
            onChangeText={setIdentity}
            style={styles.input}
            left={<TextInput.Icon icon="account-outline" />}
          />
          <Button mode="contained" onPress={handleAddHabit} style={styles.button}>
            Add Habit
          </Button>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
  },
  gradient: {
    paddingTop: 60,
    paddingHorizontal: 25,
    paddingBottom: 40,
  },
  header: {
    marginBottom: 40,
  },
  headerText: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  formContainer: {
    padding: 25,
    backgroundColor: '#FFFFFF',
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    marginTop: -20,
  },
  input: {
    marginBottom: 12,
    backgroundColor: '#F5F5F5',
  },
  button: {
    marginTop: 16,
    backgroundColor: '#FF69B4',
  },
});

export default AddHabitScreen;
