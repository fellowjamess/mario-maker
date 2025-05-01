local sounds = {
    muted = false,
    jump = love.audio.newSource("assets/sounds/SFX/jump.wav", "static"),
    death = love.audio.newSource("assets/sounds/SFX/death.wav", "static"),
    menuMusic = love.audio.newSource("assets/sounds/music/A_new_day.mp3", "stream"),
    --gameMusic = love.audio.newSource("assets/sounds/music/Stamp_it_away.mp3", "stream"),
    --editorMusic = love.audio.newSource("assets/sounds/music/In_editor.mp3", "stream")
}

local function playSound(soundName, volume, loop)
    if sounds.muted then
        return
    end
    if volume == nil then
        volume = 1
    else
        love.audio.setVolume(volume)
    end
    for sound, source in pairs(sounds) do
        if sound == soundName then
            if loop then
                source:setLooping(true)
            end
            source:play()
        end
    end
end

local function stopSound(soundName)
    for sound, source in pairs(sounds) do
        if sound == soundName then
            source:stop()
        end
    end
end

return {
    sounds = sounds,
    playSound = playSound,
    stopSound = stopSound
}