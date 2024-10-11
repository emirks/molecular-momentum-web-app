import React, { useState } from 'react';
import { View, TextInput, Button, StyleSheet, Text, Alert } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import axiosInstance from '../base_axios';

const LoginScreen = ({ navigation }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = async () => {
    try {
      // Obtain JWT tokens
      const tokenResponse = await axiosInstance.post('token/', {
        username: username,
        password: password,
      });
      
      const { access, refresh } = tokenResponse.data;
      
      // Store tokens
      await AsyncStorage.setItem('access_token', access);
      await AsyncStorage.setItem('refresh_token', refresh);

      // Set the access token for subsequent requests
      axiosInstance.defaults.headers.common['Authorization'] = `Bearer ${access}`;

      // Fetch user details
      const userResponse = await axiosInstance.get('users/');
      const user = userResponse.data.find(u => u.username === username);
      
      if (user) {
        await AsyncStorage.setItem('userId', user.id.toString());  // Convert UUID to string
        navigation.navigate('Dashboard');
      } else {
        throw new Error('User not found');
      }
    } catch (error) {
      console.error('Login failed:', error);
      if (error.response) {
        Alert.alert('Login Failed', error.response.data.detail || 'Invalid credentials');
      } else if (error.request) {
        Alert.alert('Network Error', 'Unable to connect to the server');
      } else {
        Alert.alert('Error', 'An unexpected error occurred');
      }
    }
  };

  return (
    <View style={styles.container}>
      <TextInput
        style={styles.input}
        placeholder="Username"
        value={username}
        onChangeText={setUsername}
      />
      <TextInput
        style={styles.input}
        placeholder="Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
      />
      <Button title="Login" onPress={handleLogin} />
      <Text onPress={() => navigation.navigate('Registration')}>
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
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    marginBottom: 12,
    paddingLeft: 8,
  },
});

export default LoginScreen;
