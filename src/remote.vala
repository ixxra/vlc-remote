[DBus (name="org.freedesktop.DBus.Properties")]
interface Vlc: Object {
  public abstract Variant get(string iface, string prop) throws IOError;
}

[DBus (name="org.mpris.MediaPlayer2.Player")]
interface Player: Object {
  public abstract void play() throws IOError;
  public abstract void pause() throws IOError;
  public abstract void stop() throws IOError;
  public abstract void play_pause() throws IOError;
  public abstract void next() throws IOError;
  public abstract void previous() throws IOError;
}

[DBus (name="org.mpris.MediaPlayer2.TrackList")]
interface TrackList: Object {
  public abstract HashTable<string, Variant>[] get_tracks_metadata(ObjectPath[] tracks) throws IOError;
}

int main(string[] args){
  Vlc vlc;
  Player player;
  TrackList trackList;

  try {
   vlc = Bus.get_proxy_sync(BusType.SESSION, "org.mpris.MediaPlayer2.vlc",
      "/org/mpris/MediaPlayer2");

    player = Bus.get_proxy_sync(BusType.SESSION, "org.mpris.MediaPlayer2.vlc",
      "/org/mpris/MediaPlayer2");

    trackList = Bus.get_proxy_sync(BusType.SESSION, "org.mpris.MediaPlayer2.vlc",
      "/org/mpris/MediaPlayer2");

    string cmd = args[1];

    switch (cmd) {
      case "play":
        player.play();
        break;
      case "pause":
        player.pause();
        break;
      case "toggle":
        player.play_pause();
        break;
      case "stop":
        player.stop();
        break;
      case "prev":
        player.previous();
        break;
      case "next":
        player.next();
        break;
      case "ls":
        ObjectPath[] tracks = vlc.get("org.mpris.MediaPlayer2.TrackList", "Tracks") as ObjectPath[];
        var metadata = trackList.get_tracks_metadata(tracks);

        size_t length = 0;
        stdout.printf(Json.gvariant_serialize_data(metadata, out length));
        stdout.printf("\n");
/**
        foreach (var meta in metadata){
          meta.foreach((k, v) => {
              stdout.printf(@"$k: " + v.print(true) + "\n");
            });
        }
**/
        break;
      default:
        string status = vlc.get("org.mpris.MediaPlayer2", "Identity") as string;
        stdout.printf(@"$status\n");
        break;
    }

  } catch (IOError e) {
    stderr.printf("%s\n", e.message);
    return 1;
  }

  return 0;
}
