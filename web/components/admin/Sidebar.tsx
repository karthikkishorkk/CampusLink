"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  LayoutDashboard,
  BellRing,
  FileText,
  School,
  Calendar,
  Users,
  User,
  ChevronDown,
  X,
} from "lucide-react";
import { useSupabase } from "@/components/supabase-provider"; // ✅ use session + client

export default function Sidebar({ isOpen, onClose }: { isOpen: boolean; onClose: () => void }) {

  const pathname = usePathname();
  const { session } = useSupabase(); // ✅ access session from Supabase
  const [userEmail, setUserEmail] = useState("");

  useEffect(() => {
    if (session?.user) {
      setUserEmail(session.user.email || "admin@campus.edu");
    }
  }, [session]);

  const navItems = [
    { name: "Dashboard", href: "/admin/dashboard", icon: LayoutDashboard },
    { name: "Alerts & Circulars", href: "/admin/alerts", icon: BellRing },
    { name: "Documents", href: "/admin/documents", icon: FileText },
    { name: "Classrooms", href: "/admin/classrooms", icon: School },
    { name: "Bookings", href: "/admin/bookings", icon: Calendar },
    { name: "Users", href: "/admin/users", icon: Users },
    { name: "Profile", href: "/admin/profile", icon: User },
  ];

  return (
    <>
      {/* Mobile overlay */}
      {isOpen && (
        <div
          className="fixed inset-0 bg-black/50 backdrop-blur-sm z-40 lg:hidden"
          onClick={onClose}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`
        fixed lg:sticky top-0 left-0 h-screen z-50
        w-72 bg-gradient-to-b from-[#8B1538] via-[#7A1230] to-[#6B0F28]
        text-white flex flex-col border-r border-[#A01842]/30 shadow-2xl
        transition-transform duration-300 ease-in-out
        ${isOpen ? "translate-x-0" : "-translate-x-full lg:translate-x-0"}
      `}
      >
        {/* Logo Section */}
        <div className="p-6 border-b border-[#A01842]/30 bg-[#8B1538]/50 backdrop-blur-sm">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <img
                src="/images/logo.png"
                alt="CampusLink Logo"
                className="w-12 h-12 object-contain bg-white rounded-xl p-1 shadow-lg"
              />
              <div>
                <h2 className="text-xl font-bold bg-gradient-to-r from-[#F5E6D3] to-[#D4AF37] bg-clip-text text-transparent">
                  CampusLink
                </h2>
                <p className="text-xs text-[#F5E6D3]/70">Admin Portal</p>
              </div>
            </div>
            <button
              onClick={onClose}
              className="lg:hidden p-2 hover:bg-[#A01842]/30 rounded-lg transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Navigation */}
        <nav className="flex-1 p-4 space-y-1 overflow-y-auto">
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = pathname === item.href;

            return (
              <Link
                key={item.name}
                href={item.href}
                className={`
                  w-full flex items-center gap-3 px-4 py-3 rounded-xl 
                  transition-all duration-200 group relative overflow-hidden
                  ${
                    isActive
                      ? "bg-gradient-to-r from-[#D4AF37] to-[#F5E6D3] text-[#8B1538] shadow-lg shadow-[#D4AF37]/30"
                      : "text-[#F5E6D3]/90 hover:bg-[#A01842]/30 hover:text-white"
                  }
                `}
              >
                {isActive && (
                  <div className="absolute inset-0 bg-gradient-to-r from-[#F5E6D3] to-[#D4AF37] opacity-20 animate-pulse" />
                )}
                <Icon
                  className={`w-5 h-5 relative z-10 ${
                    isActive
                      ? "text-[#8B1538]"
                      : "text-[#F5E6D3]/70 group-hover:text-[#D4AF37]"
                  } transition-colors`}
                />
                <span className="font-medium relative z-10">
                  {item.name}
                </span>
                {isActive && (
                  <div className="ml-auto w-2 h-2 bg-[#8B1538] rounded-full relative z-10" />
                )}
              </Link>
            );
          })}
        </nav>

        {/* ✅ Logged-in User Info Section */}
        <div className="p-4 border-t border-[#A01842]/30 bg-[#8B1538]/50">
          <div className="flex items-center gap-3 p-3 rounded-xl bg-[#A01842]/30 hover:bg-[#A01842]/50 transition-colors">
            <div className="w-10 h-10 bg-gradient-to-br from-[#D4AF37] to-[#F5E6D3] rounded-full flex items-center justify-center text-[#8B1538] font-bold uppercase">
              {userEmail ? userEmail[0] : "A"}
            </div>
            <div className="flex-1">
              <p className="text-sm font-semibold text-white">
                {userEmail ? userEmail.split("@")[0] : "Admin User"}
              </p>
              <p className="text-xs text-[#F5E6D3]/70 truncate">
                {userEmail || "admin@campus.edu"}
              </p>
            </div>
            <ChevronDown className="w-4 h-4 text-[#F5E6D3]/70" />
          </div>
        </div>
      </aside>
    </>
  );
}
