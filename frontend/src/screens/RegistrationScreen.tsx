import React, { useState } from 'react';
import { View, StyleSheet, Alert } from 'react-native';
import { TextInput, Button, Text } from 'react-native-paper';
import axiosInstance from '../base_axios';
import { ScreenNavigationProp } from '../types';

interface RegistrationScreenProps {
  navigation: ScreenNavigationProp;
}

const RegistrationScreen: React.FC<RegistrationScreenProps> = ({ navigation }) => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleRegister = async () => {
    try {
      const response = await axiosInstance.post('users/', {
        username,
        email,
        password,
      });
      Alert.alert('Registration Successful', 'You can now log in with your new account');
      navigation.navigate('Login');
    } catch (error) {
      console.error('Registration failed:', error);
      if (error.response) {
        Alert.alert('Registration Failed', JSON.stringify(error.response.data) || 'An error occurred');
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
        label="Username"
        value={username}
        onChangeText={setUsername}
        style={styles.input}
      />
      <TextInput
        label="Email"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
        style={styles.input}
      />
      <TextInput
        label="Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
        style={styles.input}
      />
      <Button mode="contained" onPress={handleRegister} style={styles.button}>
        Register
      </Button>
      <Text style={styles.link} onPress={() => navigation.navigate('Login')}>
        Already have an account? Login here
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

export default RegistrationScreen;
