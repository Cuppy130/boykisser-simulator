package main;

import java.io.InputStream;

public class Utils {
    public static String loadResource(String path) {
        return Utils.class.getResourceAsStream(path).toString();
    }

    public static String loadAsString(String path) {
        try(InputStream is = Utils.class.getResourceAsStream(path)){
            byte[] buffer = new byte[is.available()];
            is.read(buffer);
            return new String(buffer);
        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }
}
