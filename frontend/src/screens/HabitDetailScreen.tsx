import React, { useEffect, useState } from 'react';
import { View, StyleSheet, Alert, ScrollView } from 'react-native';
import { Text, Button, Card, Title, Paragraph } from 'react-native-paper';
import axiosInstance from '../base_axios';
import { ScreenNavigationProp, Habit } from '../types';
import { RouteProp } from '@react-navigation/native';
import LinearGradient from 'react-native-linear-gradient';
import { SafeAreaView } from 'react-native-safe-area-context';
import Icon from 'react-native-vector-icons/Ionicons';

type HabitDetailScreenRouteProp = RouteProp<RootStackParamList, 'HabitDetail'>;

interface HabitDetailScreenProps {
  route: HabitDetailScreenRouteProp;
  navigation: ScreenNavigationProp;
}

const HabitDetailScreen: React.FC<HabitDetailScreenProps> = ({ route, navigation }) => {
  const { habitId } = route.params;
  const [habit, setHabit] = useState<Habit | null>(null);

  useEffect(() => {
    fetchHabitDetails();
  }, []);

  const fetchHabitDetails = async () => {
    try {
      const response = await axiosInstance.get(`habits/${habitId}/detailed/`);
      console.log('Habit details:', response.data);
      setHabit(response.data);
    } catch (error) {
      console.error('Failed to fetch habit details:', error);
      Alert.alert('Error', 'Failed to fetch habit details');
    }
  };

  const markCompleted = async () => {
    try {
      await axiosInstance.post(`habits/${habitId}/mark-completed/`);
      fetchHabitDetails();
      Alert.alert('Success', 'Habit marked as completed');
    } catch (error) {
      console.error('Failed to mark habit as completed:', error);
      Alert.alert('Error', 'Failed to mark habit as completed');
    }
  };

  if (!habit) {
    return (
      <SafeAreaView style={styles.container}>
        <LinearGradient
          colors={['#FF69B4', '#FF8C00', '#FFA500']}
          style={styles.gradient}
        >
          <Text style={styles.loadingText}>Loading...</Text>
        </LinearGradient>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <LinearGradient
          colors={['#FF69B4', '#FF8C00', '#FFA500']}
          style={styles.gradient}
        >
          <View style={styles.header}>
            <Text style={styles.headerText}>{habit.habit_name}</Text>
          </View>
        </LinearGradient>
        <View style={styles.contentContainer}>
          <Card style={styles.card}>
            <Card.Content>
              <Title>Habit Details</Title>
              <Paragraph>Time/Location: {habit.time_location}</Paragraph>
              <Paragraph>Identity: {habit.identity}</Paragraph>
              <Paragraph>Current Streak: {habit.streak ? habit.streak.current_streak : 'N/A'}</Paragraph>
              <Paragraph>Longest Streak: {habit.streak ? habit.streak.longest_streak : 'N/A'}</Paragraph>
            </Card.Content>
          </Card>
          <Button mode="contained" onPress={markCompleted} style={styles.button}>
            Mark as Completed
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
  loadingText: {
    fontSize: 18,
    color: '#FFFFFF',
    textAlign: 'center',
  },
  contentContainer: {
    padding: 25,
    backgroundColor: '#FFFFFF',
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    marginTop: -20,
  },
  card: {
    marginBottom: 20,
  },
  button: {
    marginTop: 16,
    backgroundColor: '#FF69B4',
  },
});

export default HabitDetailScreen;
