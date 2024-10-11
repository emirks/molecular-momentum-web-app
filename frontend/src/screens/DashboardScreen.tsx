import React from 'react';
import { View, StyleSheet, Dimensions, ScrollView } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { StackNavigationProp } from '@react-navigation/stack';
import { Card, Title, Paragraph, IconButton, ProgressBar } from 'react-native-paper';
import { LineChart } from 'react-native-chart-kit';

// Define the type for the navigation prop
type RootStackParamList = {
  AddNewHabit: undefined;
  HabitDetails: { habitId: string };
};

type DashboardScreenNavigationProp = StackNavigationProp<RootStackParamList>;

const DashboardScreen: React.FC = () => {
  const navigation = useNavigation<DashboardScreenNavigationProp>();

  // Mock data for the chart
  const chartData = {
    labels: ['24.04', '26.04', '28.04', '30.04'],
    datasets: [
      {
        data: [25, 45, 50, 0],
        color: (opacity = 1) => `rgba(255, 255, 255, ${opacity})`,
        strokeWidth: 2,
      },
    ],
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <IconButton icon="arrow-left" color="#fff" onPress={() => navigation.goBack()} />
        <Title style={styles.headerTitle}>Dashboard</Title>
      </View>
      <Card style={styles.card}>
        <Card.Content>
          <View style={styles.headerRow}>
            <Title style={styles.title}>Meditate</Title>
            <IconButton 
              icon="pencil" 
              size={20} 
              color="#fff"
              onPress={() => navigation.navigate('AddNewHabit')} 
            />
          </View>
          <Paragraph style={styles.subtitle}>Find inner peace</Paragraph>

          <View style={styles.infoRow}>
            <View>
              <Paragraph style={styles.label}>Regularity</Paragraph>
              <Paragraph style={styles.value}>twice a week</Paragraph>
            </View>
            <View>
              <Paragraph style={styles.label}>Reminder</Paragraph>
              <Paragraph style={styles.value}>08:00 for 30 min</Paragraph>
            </View>
          </View>

          <View style={styles.progressSection}>
            <Title style={styles.progressTitle}>74%</Title>
            <Paragraph style={styles.progressSubtitle}>Overall progress</Paragraph>
          </View>

          <View style={styles.statsRow}>
            <View>
              <Paragraph style={styles.label}>Days in a row</Paragraph>
              <Paragraph style={styles.statsValue}>12</Paragraph>
            </View>
            <View>
              <Paragraph style={styles.label}>Record</Paragraph>
              <Paragraph style={styles.statsValue}>28</Paragraph>
            </View>
          </View>

          <Title style={styles.chartTitle}>Habit development graph</Title>
          <View style={styles.chartContainer}>
            <LineChart
              data={chartData}
              width={Dimensions.get('window').width - 64}
              height={200}
              chartConfig={{
                backgroundColor: '#1e2923',
                backgroundGradientFrom: '#1e2923',
                backgroundGradientTo: '#1e2923',
                decimalPlaces: 0,
                color: (opacity = 1) => `rgba(255, 255, 255, ${opacity})`,
                labelColor: (opacity = 1) => `rgba(255, 255, 255, ${opacity})`,
                style: {
                  borderRadius: 16,
                },
                propsForDots: {
                  r: '6',
                  strokeWidth: '2',
                  stroke: '#ffa726',
                },
              }}
              bezier
              style={styles.chart}
            />
          </View>

          <Title style={styles.historyTitle}>History</Title>
          <View style={styles.historyItem}>
            <Paragraph style={styles.historyDate}>17.04-23.04</Paragraph>
            <ProgressBar progress={1} color="#9ACD32" style={styles.progressBar} />
          </View>
          <View style={styles.historyItem}>
            <Paragraph style={styles.historyDate}>10.04-16.04</Paragraph>
            <ProgressBar progress={0.75} color="#9ACD32" style={styles.progressBar} />
          </View>
        </Card.Content>
      </Card>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#20B2AA',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 16,
    paddingHorizontal: 16,
  },
  headerTitle: {
    color: '#fff',
    fontSize: 20,
  },
  card: {
    backgroundColor: '#2E8B57',
    borderRadius: 16,
    marginHorizontal: 16,
    marginBottom: 16,
  },
  headerRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  title: {
    color: '#fff',
    fontSize: 24,
  },
  subtitle: {
    color: '#E0FFFF',
    marginBottom: 16,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 24,
  },
  label: {
    color: '#E0FFFF',
    fontSize: 14,
  },
  value: {
    color: '#fff',
    fontSize: 16,
  },
  progressSection: {
    alignItems: 'center',
    marginBottom: 24,
  },
  progressTitle: {
    color: '#fff',
    fontSize: 48,
    fontWeight: 'bold',
  },
  progressSubtitle: {
    color: '#E0FFFF',
    fontSize: 16,
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: 24,
  },
  statsValue: {
    color: '#fff',
    fontSize: 24,
    fontWeight: 'bold',
  },
  chartTitle: {
    color: '#fff',
    marginBottom: 8,
  },
  chartContainer: {
    backgroundColor: '#1e2923',
    borderRadius: 16,
    padding: 16,
    marginBottom: 24,
  },
  chart: {
    marginVertical: 8,
    borderRadius: 16,
  },
  historyTitle: {
    color: '#fff',
    marginBottom: 8,
  },
  historyItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  historyDate: {
    color: '#E0FFFF',
  },
  progressBar: {
    height: 8,
    width: 100,
    borderRadius: 4,
  },
});

export default DashboardScreen;