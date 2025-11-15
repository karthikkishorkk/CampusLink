"use client";

import { useState } from "react";
import { Menu, Search, Moon, Sun, Bell, LogOut } from "lucide-react";
import { useRouter } from "next/navigation";
import { useSupabase } from "@/components/supabase-provider";

export default function Navbar({ onMenuClick }: { onMenuClick: () => void }) {
  const [darkMode, setDarkMode] = useState(false);
  const [notifications] = useState(3);
  const router = useRouter();
  const { supabase } = useSupabase();

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.replace("/login");
  };

  return (
    <header className="sticky top-0 z-30 h-16 bg-white/90 backdrop-blur-xl border-b border-[#8B1538]/20 flex items-center justify-between px-6 shadow-sm">
      {/* Left Section */}
      <div className="flex items-center gap-4">
        <button
          onClick={onMenuClick}
          className="lg:hidden p-2 hover:bg-[#F5E6D3]/50 rounded-lg transition-colors"
        >
          <Menu className="w-5 h-5 text-[#8B1538]" />
        </button>
      </div>

      {/* Right Section */}
      <div className="flex items-center gap-3">
        <p className="text-sm text-[#8B1538]/70">
          {new Date().toLocaleString('en-IN', {
            weekday: 'short',
            hour: '2-digit',
            minute: '2-digit'
          })}
        </p>
        {/* Dark Mode Toggle */}
        {/* <button
          onClick={() => setDarkMode(!darkMode)}
          className="p-2 hover:bg-[#F5E6D3]/50 rounded-lg transition-colors text-[#8B1538]"
          title="Toggle dark mode"
        >
          {darkMode ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
        </button> */}

        {/* Logout */}
        <button
          onClick={handleLogout}
          className="p-2 hover:bg-[#F5E6D3]/50 rounded-lg transition-colors text-[#8B1538]"
          title="Logout"
        >
          <LogOut className="w-5 h-5" />
        </button>
      </div>
    </header>
  );
}
