import React, { useState } from 'react';
import { View, TextInput, Button, StyleSheet, Text, Alert } from 'react-native';
import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';

const LoginScreen = ({ navigation }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = async () => {
    try {
      const response = await axios.post('http://10.0.2.2:8000/api/token/', {
        username,
        password,
      });
      await AsyncStorage.setItem('token', response.data.access);
      navigation.navigate('Dashboard');
    } catch (error) {
      if (axios.isAxiosError(error)) {
        console.error('Login failed:', error.message);
        console.error('Response data:', error.response?.data);
        console.error('Response status:', error.response?.status);
        Alert.alert('Login Failed', error.response?.data?.detail || 'An error occurred');
      } else {
        console.error('Login failed:', error);
        Alert.alert('Login Failed', 'An unexpected error occurred');
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
