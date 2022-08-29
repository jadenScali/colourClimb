//
//  hapticManager.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-08-25.
//

import CoreHaptics

class HapticManager {
    
    let hapticEngine: CHHapticEngine

    init?() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        guard hapticCapability.supportsHaptics else {
            return nil
        }
      
        do {
          hapticEngine = try CHHapticEngine()
        } catch let error {
            print("Haptic engine Creation Error: \(error)")
            return nil
        }
    }
    
    func playRumble() {
        
      do {
        let pattern = try rumblePattern()
        try hapticEngine.start()
        let player = try hapticEngine.makePlayer(with: pattern)
        try player.start(atTime: CHHapticTimeImmediate)
        hapticEngine.notifyWhenPlayersFinished { _ in
          return .stopEngine
        }
      } catch {
        print("Failed to play slice: \(error)")
      }
    }
    
    func playSoftRumble() {
        
      do {
        let pattern = try softRumblePattern()
        try hapticEngine.start()
        let player = try hapticEngine.makePlayer(with: pattern)
        try player.start(atTime: CHHapticTimeImmediate)
        hapticEngine.notifyWhenPlayersFinished { _ in
          return .stopEngine
        }
      } catch {
        print("Failed to play slice: \(error)")
      }
    }
}

extension HapticManager {
    
    private func rumblePattern() throws -> CHHapticPattern {
        let rumble = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
        ],
        relativeTime: 0,
        duration: 1)
        
        let curve = CHHapticParameterCurve(
          parameterID: .hapticIntensityControl,
          controlPoints: [
            .init(relativeTime: 0, value: 1.0),
            .init(relativeTime: 0.25, value: 1.0),
            .init(relativeTime: 0.75, value: 0.8),
            .init(relativeTime: 0.85, value: 0.4),
            .init(relativeTime: 1, value: 0.2)
          ],
          relativeTime: 0)

        return try CHHapticPattern(events: [rumble], parameterCurves: [curve])
    }
    
    private func softRumblePattern() throws -> CHHapticPattern {
        let rumble = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.25),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
        ],
        relativeTime: 0,
        duration: 1)
        
        let curve = CHHapticParameterCurve(
          parameterID: .hapticIntensityControl,
          controlPoints: [
            .init(relativeTime: 0, value: 1.0),
            .init(relativeTime: 0.25, value: 1.0),
            .init(relativeTime: 0.75, value: 0.8),
            .init(relativeTime: 0.85, value: 0.4),
            .init(relativeTime: 1, value: 0.2)
          ],
          relativeTime: 0)

        return try CHHapticPattern(events: [rumble], parameterCurves: [curve])
    }
}
