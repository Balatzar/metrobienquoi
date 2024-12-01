module ApplicationHelper
  def format_duration(seconds)
    minutes = (seconds / 60).floor
    remaining_seconds = (seconds % 60).floor

    if minutes > 0
      "#{minutes} min #{remaining_seconds} sec"
    else
      "#{remaining_seconds} sec"
    end
  end

  def random_transport_emoji(station_name)
    emojis = %w[
      🚇 🚊 🚉 🚍 🚌 🚋 🚆 🚅 🚄 🚈
      🦊 🐱 🐶 🦁 🐯 🐼 🐨 🐮
      🍕 🍔 🍟 🌭 🍿 🧇 🥐 🥨
      ⭐️ 🌟 ✨ 💫 🌈 🎈 🎨 🎭
      🎮 🎲 🎯 🎪 🎠 🎡 🎢
      🌸 🌺 🌻 🌹 🌷 🍀 🌴
      🦄 🐉 🐲 🦕 🦖 🐳 🐋
      🎪 🗽 🗼 🎡 🎢 🎠
      🌞 🌙 ⭐️ 🌎 🌍 🌏
      🎭 🎪 🎨 🎬 🎤 🎧
      🦸‍♂️ 🦸‍♀️ 🧙‍♂️ 🧙‍♀️ 🧚‍♂️ 🧚‍♀️
    ]

    # Create a deterministic index based on the station name
    # Sum the ASCII values of the characters in the name
    sum = station_name.bytes.sum

    # Use modulo to get an index within the array bounds
    index = sum % emojis.length

    emojis[index]
  end
end
