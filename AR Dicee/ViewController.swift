//
//  ViewController.swift
//  AR Dicee
//
//  Created by KOPPOLA GOKUL SAI on 01/01/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        //let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        let sphere = SCNSphere(radius: 0.2)
//        
//        let Material = SCNMaterial()
//        
//        Material.diffuse.contents =  UIImage(named: "art.scnassets/moonTexture.jpeg")
//        
//        
//        sphere.materials = [Material]
//        
//        let node = SCNNode()
//        
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.20)
//        
//        node.geometry = sphere
//        
//        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//        
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: sceneView)
            
            if let query = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .any) {
                let results = sceneView.session.raycast(query)
                if let rayResult = results.first {
                    let diceScene = SCNScene(named: "art.scnassets/dice.scn")!
                    if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true){
                        
                        diceNode.position = SCNVector3(x: rayResult.worldTransform.columns.3.x,
                                                       y: rayResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                                                       z: rayResult.worldTransform.columns.3.z)
                        diceArray.append(diceNode)
                        sceneView.scene.rootNode.addChildNode(diceNode)
                        
                        
                        
                    }
                }
            }
        }
    }
    
    @IBAction func RollButton(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    @IBAction func removeDice(_ sender: UIBarButtonItem) {
        if !diceArray.isEmpty{
            for dice in diceArray{
                dice.removeFromParentNode()
            }
        }
        
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    func rollAll(){
        if !diceArray.isEmpty {
            for dice in diceArray{
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode){
        // for animation
        let randomX = Float( (arc4random_uniform(4)+1) ) * (Float.pi/2)
        let randomZ = Float( (arc4random_uniform(4)+1) ) * (Float.pi/2)
        
        dice.runAction(
            SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5)
        )
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor{
            
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        }
        else{
            return
        }
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//            guard anchor is ARPlaneAnchor else {
//                return
//            }
//           
//            let planeAnchor = anchor as! ARPlaneAnchor
//            let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height))
//            let planeNode = SCNNode()
//            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
//            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
//            let gridMaterial = SCNMaterial()
//            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
//            plane.materials = [gridMaterial]
//            planeNode.geometry = plane
//            node.addChildNode(planeNode)
//
//    }


}
