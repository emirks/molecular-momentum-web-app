import React, { useState } from 'react';
import { View, StyleSheet, Alert, ScrollView, Image } from 'react-native';
import { TextInput, Button, Text } from 'react-native-paper';
import AsyncStorage from '@react-native-async-storage/async-storage';
import axiosInstance from '../base_axios';
import { ScreenNavigationProp } from '../types';
import LinearGradient from 'react-native-linear-gradient';
import { SafeAreaView } from 'react-native-safe-area-context';

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
        await AsyncStorage.setItem('username', user.username); // Add this line
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
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <LinearGradient
          colors={['#FF69B4', '#FF8C00', '#FFA500']}
          style={styles.gradient}
        >
          <View style={styles.header}>
            <Text style={styles.headerText}>Welcome Back</Text>
          </View>
          <Image
            source={require('../assets/login-image.jpg')}
            style={styles.loginImage}
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
  loginImage: {
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

export default LoginScreen;
