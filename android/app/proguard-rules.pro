# Flutter engine and embedding
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase / Google Play services
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Paystack SDK
-keep class co.paystack.** { *; }
-keep class com.paystack.** { *; }
-dontwarn co.paystack.**
-dontwarn com.paystack.**

# Kotlin metadata used by reflection in plugins
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod
-keep class kotlin.Metadata { *; }

# Keep enum values used through reflection by JSON libraries
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
