import React, { useEffect, useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, ScrollView, Image, StatusBar, Alert } from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from 'react-native-vector-icons/Ionicons';
import { SafeAreaView } from 'react-native-safe-area-context';
import axiosInstance from '../base_axios';
import { ScreenNavigationProp, Habit } from '../types';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface DashboardScreenProps {
  navigation: ScreenNavigationProp;
}

const DashboardScreen: React.FC<DashboardScreenProps> = ({ navigation }) => {
  const [habits, setHabits] = useState<Habit[]>([]);
  const [username, setUsername] = useState<string>('');

  useEffect(() => {
    fetchHabits();
    fetchUsername();
  }, []);

  const fetchUsername = async () => {
    try {
      let storedUsername = await AsyncStorage.getItem('username');
      if (!storedUsername) {
        const userId = await AsyncStorage.getItem('userId');
        if (!userId) {
          throw new Error('User ID not found');
        }
        const response = await axiosInstance.get(`users/${userId}/`);
        storedUsername = response.data.username;
        await AsyncStorage.setItem('username', storedUsername);
      }
      setUsername(storedUsername);
    } catch (error) {
      console.error('Failed to fetch username:', error);
      Alert.alert('Error', 'Failed to fetch username');
    }
  };

  const fetchHabits = async () => {
    try {
      const userId = await AsyncStorage.getItem('userId');
      if (!userId) {
        throw new Error('User ID not found');
      }
      const response = await axiosInstance.get(`users/${userId}/habits/`);
      setHabits(response.data);
    } catch (error) {
      console.error('Failed to fetch habits:', error);
      Alert.alert('Error', 'Failed to fetch habits');
    }
  };

  const handleAddHabit = () => {
    navigation.navigate('AddHabit');
  };

  const handleHabitPress = (habitId: number) => {
    navigation.navigate('HabitDetail', { habitId });
  };

  const handleMarkCompleted = async (habitId: number) => {
    try {
      await axiosInstance.post(`habits/${habitId}/mark-completed/`);
      fetchHabits(); // Refresh the habits list
      Alert.alert('Success', 'Habit marked as completed');
    } catch (error) {
      console.error('Failed to mark habit as completed:', error);
      Alert.alert('Error', 'Failed to mark habit as completed');
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#FF69B4" />
      <ScrollView>
        <LinearGradient
          colors={['#FF69B4', '#FF8C00', '#FFA500']}
          style={styles.gradient}
        >
          <View style={styles.header}>
            <View>
              <Text style={styles.dateText}>Today</Text>
              <Text style={styles.dayText}>{new Date().toLocaleDateString('en-US', { weekday: 'long', month: 'short', day: 'numeric' })}</Text>
            </View>
            <Image
              source={require('../assets/profile-pic.jpg')}
              style={styles.profilePic}
            />
          </View>
          
          <View style={styles.greetingContainer}>
            <Text style={styles.greetingText}>
              RISE AND{'\n'}SHINE, {username ? username.toUpperCase() : 'USER'}!
            </Text>
            <Text style={styles.subGreetingText}>
              HOW ARE YOU FEELING{'\n'}TODAY?
            </Text>
          </View>
          
          <TouchableOpacity style={styles.button} onPress={handleAddHabit}>
            <Icon name="add" size={24} color="#FFF" />
            <Text style={styles.buttonText}>Add New Habit</Text>
          </TouchableOpacity>
        </LinearGradient>
        
        <View style={styles.routineContainer}>
          <View style={styles.routineHeader}>
            <Text style={styles.routineTitle}>Your Habits</Text>
          </View>
          {habits.map((habit) => (
            <TouchableOpacity key={habit.id} style={styles.taskItem} onPress={() => handleHabitPress(habit.id)}>
              <Text style={styles.taskText}>{habit.habit_name}</Text>
              <TouchableOpacity style={styles.markAsDoneButton} onPress={() => handleMarkCompleted(habit.id)}>
                <Text style={styles.markAsDoneText}>Mark as done</Text>
              </TouchableOpacity>
            </TouchableOpacity>
          ))}
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
    paddingTop: StatusBar.currentHeight + 20,
    paddingHorizontal: 25,
    paddingBottom: 40,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 40,
  },
  dateText: {
    fontSize: 28,
    color: '#FFFFFF',
    fontWeight: 'bold',
  },
  dayText: {
    fontSize: 18,
    color: '#FFFFFF',
    marginTop: 5,
  },
  profilePic: {
    width: 60,
    height: 60,
    borderRadius: 30,
    borderWidth: 2,
    borderColor: '#FFFFFF',
  },
  greetingContainer: {
    marginBottom: 40,
  },
  greetingText: {
    fontSize: 40,
    fontWeight: 'bold',
    color: '#FFFFFF',
    lineHeight: 48,
    letterSpacing: 1,
  },
  subGreetingText: {
    fontSize: 22,
    color: '#FFFFFF',
    marginTop: 20,
    lineHeight: 30,
  },
  arrowButton: {
    position: 'absolute',
    right: 0,
    bottom: 0,
    backgroundColor: '#FFFFFF',
    borderRadius: 25,
    width: 50,
    height: 50,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
    elevation: 5,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 20,
  },
  button: {
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
    paddingVertical: 15,
    paddingHorizontal: 25,
    borderRadius: 30,
    flexDirection: 'row',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  buttonText: {
    color: '#FFFFFF',
    fontWeight: 'bold',
    fontSize: 16,
    marginLeft: 10,
  },
  routineContainer: {
    padding: 25,
    backgroundColor: '#FFFFFF',
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    marginTop: -20, // Overlap with the gradient section
  },
  routineHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  routineTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
  },
  moreOptions: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#333',
  },
  routineInfo: {
    backgroundColor: '#F5F5F5',
    borderRadius: 20,
    padding: 15,
    marginBottom: 20,
  },
  routineInfoText: {
    color: '#666666',
    fontSize: 16,
    flexDirection: 'row',
    alignItems: 'center',
  },
  taskItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    borderBottomWidth: 1,
    borderBottomColor: '#EEEEEE',
    paddingVertical: 20,
  },
  taskText: {
    fontSize: 18,
    color: '#333',
  },
  markAsDoneButton: {
    backgroundColor: '#000000',
    paddingVertical: 10,
    paddingHorizontal: 20,
    borderRadius: 25,
  },
  markAsDoneText: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: 'bold',
  },
});

export default DashboardScreen;
