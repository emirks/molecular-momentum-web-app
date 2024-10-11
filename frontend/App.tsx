/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { Provider as PaperProvider } from 'react-native-paper';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import LoginScreen from './src/screens/LoginScreen';
import RegistrationScreen from './src/screens/RegistrationScreen';
import DashboardScreen from './src/screens/DashboardScreen';
import HabitDetailScreen from './src/screens/HabitDetailScreen';
import AddHabitScreen from './src/screens/AddHabitScreen';
import { RootStackParamList } from './src/types';

const Stack = createStackNavigator<RootStackParamList>();

const App = () => {
  return (
    <SafeAreaProvider>
      <PaperProvider>
        <NavigationContainer>
          <Stack.Navigator initialRouteName="Login">
            <Stack.Screen name="Login" component={LoginScreen} />
            <Stack.Screen name="Registration" component={RegistrationScreen} />
            <Stack.Screen 
              name="Dashboard" 
              component={DashboardScreen} 
              options={{ headerShown: false }}
            />
            <Stack.Screen name="HabitDetail" component={HabitDetailScreen} />
            <Stack.Screen name="AddHabit" component={AddHabitScreen} />
          </Stack.Navigator>
        </NavigationContainer>
      </PaperProvider>
    </SafeAreaProvider>
  );
};

export default App;
