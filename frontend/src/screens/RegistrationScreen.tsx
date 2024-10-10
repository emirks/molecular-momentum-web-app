import React, { useState } from 'react';
import { View, TextInput, Button, StyleSheet, Alert } from 'react-native';
import axios from 'axios';

const RegistrationScreen = ({ navigation }) => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleRegister = async () => {
    try {
      const response = await axios.post('http://10.0.2.2:8000/api/users/', {
        username,
        email,
        password,
      });
      Alert.alert('Registration Successful', 'You can now log in with your new account');
      navigation.navigate('Login');
    } catch (error) {
      if (axios.isAxiosError(error)) {
        console.error('Registration failed:', error.message);
        console.error('Response data:', error.response?.data);
        console.error('Response status:', error.response?.status);
        Alert.alert('Registration Failed', JSON.stringify(error.response?.data) || 'An error occurred');
      } else {
        console.error('Registration failed:', error);
        Alert.alert('Registration Failed', 'An unexpected error occurred');
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
        placeholder="Email"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
      />
      <TextInput
        style={styles.input}
        placeholder="Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
      />
      <Button title="Register" onPress={handleRegister} />
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

export default RegistrationScreen;
