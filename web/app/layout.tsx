import "./globals.css";
import type { Metadata } from "next";
import SupabaseProvider from "@/components/supabase-provider";

export const metadata: Metadata = {
  title: "CampusLink",
  description: "CampusLink – Admin and Mobile Portal",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-gray-50 text-gray-900">
        <SupabaseProvider>{children}</SupabaseProvider>
      </body>
    </html>
  );
}
