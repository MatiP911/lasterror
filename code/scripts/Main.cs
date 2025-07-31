using Godot;
using System;

public partial class Main : Node2D
{
    private Node sceneContainer;

    public override void _Ready()
    {
        sceneContainer = GetNode("SceneContainer");

        LoadScene("res://level/scene/all.tscn");
    }

    public void LoadScene(string scenePath)
    {
        // Clear last scene
        foreach (Node child in sceneContainer.GetChildren())
        {
            child.QueueFree();
        }

        // Load new scene
        var packed = GD.Load<PackedScene>(scenePath);
        if (packed != null)
        {
            var instance = packed.Instantiate();
            sceneContainer.AddChild(instance);
        }
        else
        {
            GD.PushError("Can not load scene: " + scenePath);
        }
    }
}
