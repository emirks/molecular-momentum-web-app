import React, { useState } from 'react';
import { View, StyleSheet, Alert } from 'react-native';
import { TextInput, Button, Text } from 'react-native-paper';
import AsyncStorage from '@react-native-async-storage/async-storage';
import axiosInstance from '../base_axios';
import { ScreenNavigationProp } from '../types';

interface LoginScreenProps {
  navigation: ScreenNavigationProp;
}

const LoginScreen: React.FC<LoginScreenProps> = ({ navigation }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = async () => {
    try {
      const tokenResponse = await axiosInstance.post('token/', {
        username: username,
        password: password,
      });
      
      const { access, refresh } = tokenResponse.data;
      
      await AsyncStorage.setItem('access_token', access);
      await AsyncStorage.setItem('refresh_token', refresh);
      
      axiosInstance.defaults.headers.common['Authorization'] = `Bearer ${access}`;
      
      const userResponse = await axiosInstance.get('users/');
      const user = userResponse.data.find(u => u.username === username);
      
      if (user) {
        await AsyncStorage.setItem('userId', user.id.toString());
        navigation.navigate('Dashboard');
      } else {
        throw new Error('User not found');
      }
    } catch (error) {
      console.error('Login failed:', error);
      Alert.alert('Login Failed', 'Invalid credentials');
    }
  };

  return (
    <View style={styles.container}>
      <TextInput
        label="Username"
        value={username}
        onChangeText={setUsername}
        style={styles.input}
      />
      <TextInput
        label="Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
        style={styles.input}
      />
      <Button mode="contained" onPress={handleLogin} style={styles.button}>
        Login
      </Button>
      <Text style={styles.link} onPress={() => navigation.navigate('Registration')}>
        Don't have an account? Register here
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    padding: 16,
  },
  input: {
    marginBottom: 12,
  },
  button: {
    marginTop: 16,
  },
  link: {
    marginTop: 16,
    textAlign: 'center',
    color: 'blue',
  },
});

export default LoginScreen;
