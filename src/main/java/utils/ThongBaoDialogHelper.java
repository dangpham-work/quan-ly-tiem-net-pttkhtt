package utils;

/**
 * ThongBaoDialogHelper - Đã được vô hiệu hóa cho phiên bản Web.
 * Class này trước đây dùng JavaFX Dialog, hiện không còn cần trong Web App.
 */
public class ThongBaoDialogHelper {
    private ThongBaoDialogHelper() {}

    public static void showSuccess(Object scene, String message) {
        System.out.println("[SUCCESS] " + message);
    }

    public static void showError(Object scene, String message) {
        System.out.println("[ERROR] " + message);
    }

    public static void showWarning(Object scene, String message) {
        System.out.println("[WARNING] " + message);
    }

    public static void showInfo(Object scene, String message) {
        System.out.println("[INFO] " + message);
    }
}
