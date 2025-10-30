import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart' show ARHitTestResultType;
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart'; 
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart'; 
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  // Ensure Flutter is initialized before running the app (good practice)
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CuboidSizeEstimatorApp());
}

class CuboidSizeEstimatorApp extends StatelessWidget {
  const CuboidSizeEstimatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'AR Cuboid Estimator',
      home: CuboidViewScreen(),
    );
  }
}

class CuboidViewScreen extends StatefulWidget {
  const CuboidViewScreen({super.key});

  @override
  State<CuboidViewScreen> createState() => _CuboidViewScreenState();
}

class _CuboidViewScreenState extends State<CuboidViewScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARAnchor? currentAnchor;

  // Define the fixed size for the demo cuboid in meters (e.g., a 1-meter cube)
  final vector.Vector3 estimatedSize = vector.Vector3(1.0, 1.0, 1.0); 
  
  // A publicly available simple Box model in GLB format from Khronos Group
  final String boxModelUri = 
      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Box/glTF-Binary/Box.glb';

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

// Called when the ARSession is created
void onARSessionCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
    ) {
  this.arSessionManager = arSessionManager;
  this.arObjectManager = arObjectManager;

  // Initialize the session with default settings
  this.arSessionManager.onInitialize();

  
  // 1. Set a listener for when a plane is tapped
  this.arSessionManager.onPlaneOrPointTap = _onPlaneOrPointTapped; 

 
 
}
  
 // Function to handle plane and point taps, replacing _onPlaneTap
void _onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) {
  // Try to find a successful hit result that identifies a plane
  final singleHitTestResult = hitTestResults.firstWhere(
    (result) => result.type == ARHitTestResultType.plane,
  );

  // We found a plane, so we create a new ARPlaneAnchor from the transformation
  final newAnchor = ARPlaneAnchor(
      transformation: singleHitTestResult.worldTransform
  );
  
  // Now call the place cuboid function with the created anchor
  _placeCuboid(newAnchor);
}

  // Core logic to place the bounding box (cuboid)
  void _placeCuboid(ARAnchor anchor) async {
    // 1. Clear any existing anchor/cuboid before placing a new one
    if (currentAnchor != null) {
      // Assuming we only want one bounding box at a time
      await arObjectManager.removeNode(currentAnchor!.name as ARNode);
      currentAnchor = null;
    }

    // 2. Create the AR Node (the cuboid bounding box)
    final ARNode cuboidNode = ARNode(
      type: NodeType.webGLB, // Use webGLB for remote models
      uri: boxModelUri,      // The URL of the 3D Box model
      
      // Use the anchor's transformation for placement
      transformation: anchor.transformation, 
      
      // This is the crucial step for size estimation:
      // We scale the object to represent the estimated bounding box size (1m x 1m x 1m in this demo)
      scale: estimatedSize, 
      name: 'BoundingBoxCuboid',
    );

    // 3. Add the node to the AR session
    bool success = await arObjectManager.addNode(cuboidNode) ?? false;
    if(!mounted) return;
    if (success) {
      currentAnchor = anchor;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cuboid (1m x 1m x 1m) placed!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place cuboid.')),
      );
    }
  }
  
  // A simple method to clear all objects
  void _clearCuboid() async {
    if (currentAnchor != null) {
      await arObjectManager.removeNode(currentAnchor!.name as ARNode);
      if(!mounted) return;
      currentAnchor = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cuboid cleared.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Size Estimator Demo'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          // 1. The AR View (Camera Feed)
          ARView(
            onARViewCreated: onARSessionCreated,
            // Enable plane detection visualization to guide the user
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
            
          ),
          // 2. Clear Button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0, right: 16.0),
              child: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red, size: 40),
                onPressed: _clearCuboid,
                tooltip: 'Clear Cuboid',
              ),
            ),
          ),
          // 3. Instructional Overlay
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                '1. Move camera to detect a surface (dots will appear).\n2. Tap the surface to place a 1-meter bounding box.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, backgroundColor: Colors.black54, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}