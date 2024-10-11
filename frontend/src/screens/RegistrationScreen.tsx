import React, { useState } from 'react';
import { View, StyleSheet, Alert, ScrollView, Image } from 'react-native';
import { TextInput, Button, Text } from 'react-native-paper';
import axiosInstance from '../base_axios';
import { ScreenNavigationProp } from '../types';
import LinearGradient from 'react-native-linear-gradient';
import { SafeAreaView } from 'react-native-safe-area-context';

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
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <LinearGradient
          colors={['#FF69B4', '#FF8C00', '#FFA500']}
          style={styles.gradient}
        >
          <View style={styles.header}>
            <Text style={styles.headerText}>Create Account</Text>
          </View>
          <Image
            source={require('../assets/registration-image.png')}
            style={styles.registrationImage}
          />
        </LinearGradient>
        <View style={styles.formContainer}>
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
  registrationImage: {
    width: '100%',
    height: 200,
    resizeMode: 'contain',
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
  link: {
    marginTop: 16,
    textAlign: 'center',
    color: '#FF69B4',
  },
});

export default RegistrationScreen;
