import 'package:flutter/material.dart';
import 'services/tracking_channel_service.dart';
import 'components/tracking_channel_card.dart';

class TrackingChannelsScreen extends StatefulWidget {
  const TrackingChannelsScreen({Key? key}) : super(key: key);

  @override
  _TrackingChannelsScreenState createState() => _TrackingChannelsScreenState();
}

class _TrackingChannelsScreenState extends State<TrackingChannelsScreen> {
  List<Map<String, dynamic>> _trackingChannels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrackingChannels();
  }

  Future<void> _fetchTrackingChannels() async {
    try {
      final channels = await TrackingChannelService.getTrackingChannels();
      setState(() {
        _trackingChannels = List<Map<String, dynamic>>.from(channels);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching tracking channels: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking Channels'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink.shade300, Colors.orange.shade300],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _trackingChannels.isEmpty
              ? Center(child: Text('No tracking channels found'))
              : ListView.builder(
                  itemCount: _trackingChannels.length,
                  itemBuilder: (context, index) {
                    return TrackingChannelCard(
                      channelData: _trackingChannels[index],
                    );
                  },
                ),
    );
  }
}

