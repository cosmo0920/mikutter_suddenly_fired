# -*- coding: utf-8 -*-

# Please forgive me Akkiesoft!! ヽ('ω')ﾉ三ヽ('ω')ﾉもうしわけねぇもうしわけねぇ

# Original: https://github.com/Akkiesoft/mikutter_suddenly_death
# http://d.hatena.ne.jp/ux00ff/20120721/1342878538
class String
  def screen_width
    hankaku_len = self.each_char.count {|x| x.ascii_only? }
    hankaku_len + (self.size - hankaku_len) * 2
  end
end

Plugin.create :mikutter_suddenly_fired do
	command(:suddenly_fired,
		name: '突然の焼き',
		condition: lambda{ |opt| true },
		visible: true,
		role: :postbox
	) do |opt|
		begin
			max_length = 0

			# メッセージを取得してバラバラにする（意味深）
			message = Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text.split("\n")
			message.each do |line|
				# 一番長い行を調べる
				length = line.screen_width / 2 + 1
				if max_length < length then
					max_length = length
				end
			end

			# 上下のアレをアレする
			i = 0
			line1 = "🔥🔥"
			line3 = "🔥🔥"
			while max_length != i do
				line1 += "🔥"
				line3 += "🔥"
				i += 1
			end

			# ツイーヨをつくります
			str = line1 + "🔥\n"
			message.each do |line|
				i = line.screen_width / 2 + 1
				while max_length != i do
					line += "　"
					i += 1
				end
				str += "🔥　#{line}　🔥\n"
			end
			str += line3 + "🔥"

			# 突然の死
			if UserConfig[:suddenly_fire_immediate] then
				Post.primary_service.update(:message => str)
				Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text = ""
			else
				Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text = str
			end
		end
	end

	settings "突然の焼き" do
		boolean('すぐに投稿する', :suddenly_fire_immediate)
	end
end
