function F_animation_writer(frames, exporttype, filename)
switch exporttype % 今回は出力方法を exporttype 変数で指定することにする
    case 'mp4' % 普通の動画の場合
        video = VideoWriter(filename, 'MPEG-4'); % ファイル名や出力形式などを設定
        open(video); % 書き込むファイルを開く
        writeVideo(video, frames); % ファイルに書き込む
        close(video); % 書き込むファイルを閉じる
    case 'gif'
        filename = [filename '.gif']; % ファイル名
        for i = 1:size(frames,2)
            [A, map] = rgb2ind(frame2im(frames(i)), 256); % 画像形式変換
            if i == 1
                imwrite(A, map, filename, 'gif','LoopCount',Inf, 'DelayTime', 1/10); % 出力形式(30FPS)を設定
            else
                imwrite(A, map, filename, 'gif', 'DelayTime', 1/10, 'WriteMode', 'append'); % 2フレーム目以降は"追記"の設定も必要
            end
        end
end
end