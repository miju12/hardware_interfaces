/*
 * Copyright (C) 2020 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.hardware.automotive.audiocontrol;

import android.hardware.automotive.audiocontrol.AudioFocusChange;
import android.hardware.automotive.audiocontrol.DuckingInfo;
import android.hardware.automotive.audiocontrol.MutingInfo;
import android.hardware.automotive.audiocontrol.IFocusListener;

/**
 * Interacts with the car's audio subsystem to manage audio sources and volumes
 */
@VintfStability
interface IAudioControl {
    /**
     * Notifies HAL of changes in audio focus status for focuses requested or abandoned by the HAL.
     *
     * This will be called in response to IFocusListener's requestAudioFocus and
     * abandonAudioFocus, as well as part of any change in focus being held by the HAL due focus
     * request from other activities or services.
     *
     * The HAL is not required to wait for an callback of AUDIOFOCUS_GAIN before playing audio, nor
     * is it required to stop playing audio in the event of a AUDIOFOCUS_LOSS callback is received.
     *
     * @param usage The audio usage associated with the focus change {@code AttributeUsage}. See
     * {@code audioUsage} in audio_policy_configuration.xsd for the list of allowed values.
     * @param zoneId The identifier for the audio zone that the HAL is playing the stream in
     * @param focusChange the AudioFocusChange that has occurred.
     */
    oneway void onAudioFocusChange(in String usage, in int zoneId, in AudioFocusChange focusChange);

    /**
     * Notifies HAL of changes in output devices that the HAL should apply ducking to.
     *
     * This will be called in response to changes in audio focus, and will include a
     * {@link DuckingInfo} object per audio zone that experienced a change in audo focus.
     *
     * @param duckingInfos an array of {@link DuckingInfo} objects for the audio zones where audio
     * focus has changed.
     */
     oneway void onDevicesToDuckChange(in DuckingInfo[] duckingInfos);

     /**
      * Notifies HAL of changes in output devices that the HAL should apply muting to.
      *
      * This will be called in response to changes in audio mute state for each volume group
      * and will include a {@link MutingInfo} object per audio zone that experienced a mute state
      * event.
      *
      * @param mutingInfos an array of {@link MutingInfo} objects for the audio zones where audio
      * mute state has changed.
      */
     oneway void onDevicesToMuteChange(in MutingInfo[] mutingInfos);

    /**
     * Registers focus listener to be used by HAL for requesting and abandoning audio focus.
     *
     * It is expected that there will only ever be a single focus listener registered. If the
     * observer dies, the HAL implementation must unregister observer automatically. If called when
     * a listener is already registered, the existing one should be unregistered and replaced with
     * the new listener.
     *
     * @param listener the listener interface.
     */
    oneway void registerFocusListener(in IFocusListener listener);

    /**
     * Control the right/left balance setting of the car speakers.
     *
     * This is intended to shift the speaker volume toward the right (+) or left (-) side of
     * the car. 0.0 means "centered". +1.0 means fully right. -1.0 means fully left.
     *
     * A value outside the range -1 to 1 must be clamped by the implementation to the -1 to 1
     * range.
     */
    oneway void setBalanceTowardRight(in float value);

    /**
     * Control the fore/aft fade setting of the car speakers.
     *
     * This is intended to shift the speaker volume toward the front (+) or back (-) of the car.
     * 0.0 means "centered". +1.0 means fully forward. -1.0 means fully rearward.
     *
     * A value outside the range -1 to 1 must be clamped by the implementation to the -1 to 1
     * range.
     */
    oneway void setFadeTowardFront(in float value);
}