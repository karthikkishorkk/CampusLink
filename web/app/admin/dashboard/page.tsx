"use client";

import { useState } from 'react';
import { 
  TrendingUp, Users, AlertCircle, FileText, School, Activity, 
  ArrowUpRight, ArrowDownRight, Bell, CheckCircle, Clock,
  LayoutDashboard, BookOpen, Calendar, Settings, User, Menu, X,
  Search, Moon, Sun, ChevronDown, LogOut, BellRing
} from 'lucide-react';

interface SidebarProps {
  isOpen: boolean;
  onClose: () => void;
}


// Sidebar Component
function Sidebar({ isOpen, onClose }: SidebarProps) {
  const [activeItem, setActiveItem] = useState("/admin/dashboard");
  
  const navItems = [
    { name: "Dashboard", href: "/admin/dashboard", icon: LayoutDashboard },
    { name: "Alerts & Circulars", href: "/admin/alerts", icon: BellRing },
    { name: "Documents", href: "/admin/documents", icon: FileText },
    { name: "Classrooms", href: "/admin/classrooms", icon: School },
    { name: "Bookings", href: "/admin/bookings", icon: Calendar },
    { name: "Users", href: "/admin/users", icon: Users },
    { name: "Profile", href: "/admin/profile", icon: User },
    { name: "Settings", href: "/admin/settings", icon: Settings },
  ];

  return (
    <>
      {/* Mobile Overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/50 backdrop-blur-sm z-40 lg:hidden"
          onClick={onClose}
        />
      )}
      
      {/* Sidebar */}
      <aside className={`
        fixed lg:sticky top-0 left-0 h-screen z-50
        w-72 bg-gradient-to-b from-[#8B1538] via-[#7A1230] to-[#6B0F28]
        text-white flex flex-col border-r border-[#A01842]/30 shadow-2xl
        transition-transform duration-300 ease-in-out
        ${isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'}
      `}>
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
            const isActive = activeItem === item.href;
            
            return (
              <button
                key={item.name}
                onClick={() => setActiveItem(item.href)}
                className={`
                  w-full flex items-center gap-3 px-4 py-3 rounded-xl 
                  transition-all duration-200 group relative overflow-hidden
                  ${isActive 
                    ? 'bg-gradient-to-r from-[#D4AF37] to-[#F5E6D3] text-[#8B1538] shadow-lg shadow-[#D4AF37]/30' 
                    : 'text-[#F5E6D3]/90 hover:bg-[#A01842]/30 hover:text-white'
                  }
                `}
              >
                {isActive && (
                  <div className="absolute inset-0 bg-gradient-to-r from-[#F5E6D3] to-[#D4AF37] opacity-20 animate-pulse" />
                )}
                <Icon className={`w-5 h-5 relative z-10 ${isActive ? 'text-[#8B1538]' : 'text-[#F5E6D3]/70 group-hover:text-[#D4AF37]'} transition-colors`} />
                <span className="font-medium relative z-10">{item.name}</span>
                {isActive && (
                  <div className="ml-auto w-2 h-2 bg-[#8B1538] rounded-full relative z-10" />
                )}
              </button>
            );
          })}
        </nav>

        {/* User Section */}
        <div className="p-4 border-t border-[#A01842]/30 bg-[#8B1538]/50">
          <div className="flex items-center gap-3 p-3 rounded-xl bg-[#A01842]/30 hover:bg-[#A01842]/50 transition-colors cursor-pointer">
            <div className="w-10 h-10 bg-gradient-to-br from-[#D4AF37] to-[#F5E6D3] rounded-full flex items-center justify-center text-[#8B1538] font-bold">
              A
            </div>
            <div className="flex-1">
              <p className="text-sm font-semibold text-white">Admin User</p>
              <p className="text-xs text-[#F5E6D3]/70">admin@campus.edu</p>
            </div>
            <ChevronDown className="w-4 h-4 text-[#F5E6D3]/70" />
          </div>
        </div>
      </aside>
    </>
  );
}

interface NavbarProps {
  onMenuClick: () => void; // a function with no arguments and no return value
}

// Navbar Component
function Navbar({ onMenuClick }: NavbarProps) {
  const [darkMode, setDarkMode] = useState(false);
  const [notifications, setNotifications] = useState(3);

  return (
    <header className="sticky top-0 z-30 h-16 bg-white/90 backdrop-blur-xl border-b border-[#8B1538]/20 flex items-center justify-between px-6 shadow-sm">
      <div className="flex items-center gap-4">
        <button 
          onClick={onMenuClick}
          className="lg:hidden p-2 hover:bg-[#F5E6D3]/50 rounded-lg transition-colors"
        >
          <Menu className="w-5 h-5 text-[#8B1538]" />
        </button>
        
        <div className="relative hidden md:block">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#8B1538]/50" />
          <input 
            type="text"
            placeholder="Search..."
            className="pl-10 pr-4 py-2 w-64 bg-[#F5E6D3]/30 border border-[#8B1538]/20 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#8B1538] focus:border-transparent transition-all placeholder:text-[#8B1538]/50"
          />
        </div>
      </div>

      <div className="flex items-center gap-3">
        <button 
          onClick={() => setDarkMode(!darkMode)}
          className="p-2 hover:bg-[#F5E6D3]/50 rounded-lg transition-colors text-[#8B1538]"
          title="Toggle dark mode"
        >
          {darkMode ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
        </button>

        <button className="relative p-2 hover:bg-[#F5E6D3]/50 rounded-lg transition-colors text-[#8B1538]">
          <Bell className="w-5 h-5" />
          {notifications > 0 && (
            <span className="absolute top-1 right-1 w-4 h-4 bg-[#8B1538] text-white text-xs rounded-full flex items-center justify-center font-bold">
              {notifications}
            </span>
          )}
        </button>

        <div className="hidden sm:flex items-center gap-3 pl-3 border-l border-[#8B1538]/20">
          <div className="w-8 h-8 bg-gradient-to-br from-[#8B1538] to-[#A01842] rounded-full flex items-center justify-center text-white text-sm font-bold">
            A
          </div>
          <div className="hidden lg:block">
            <p className="text-sm font-semibold text-[#8B1538]">Admin User</p>
            <p className="text-xs text-[#8B1538]/60">Administrator</p>
          </div>
        </div>

        <button className="p-2 hover:bg-[#F5E6D3]/50 rounded-lg transition-colors text-[#8B1538]" title="Logout">
          <LogOut className="w-5 h-5" />
        </button>
      </div>
    </header>
  );
}

// Main Dashboard Component
export default function AdminDashboard() {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  const stats = [
    { 
      title: "Total Users", 
      value: "1,245", 
      change: "+12.5%",
      trend: "up",
      icon: Users,
      color: "from-[#8B1538] to-[#A01842]",
      bgColor: "bg-[#F5E6D3]/50",
      textColor: "text-[#8B1538]"
    },
    { 
      title: "Active Alerts", 
      value: "12", 
      change: "-3.2%",
      trend: "down",
      icon: AlertCircle,
      color: "from-[#DC2626] to-[#B91C1C]",
      bgColor: "bg-red-50",
      textColor: "text-red-600"
    },
    { 
      title: "Pending Documents", 
      value: "34", 
      change: "+8.1%",
      trend: "up",
      icon: FileText,
      color: "from-[#D4AF37] to-[#B8941F]",
      bgColor: "bg-[#F5E6D3]/30",
      textColor: "text-[#B8941F]"
    },
    { 
      title: "Classrooms", 
      value: "18", 
      change: "+2.0%",
      trend: "up",
      icon: School,
      color: "from-emerald-500 to-emerald-600",
      bgColor: "bg-emerald-50",
      textColor: "text-emerald-600"
    },
  ];

  const recentActivity = [
    { 
      id: 1,
      icon: Bell,
      title: "3 new alerts posted today",
      time: "2 hours ago",
      type: "alert",
      color: "text-[#8B1538]",
      bgColor: "bg-[#F5E6D3]/50"
    },
    { 
      id: 2,
      icon: Users,
      title: "New teacher account created",
      time: "4 hours ago",
      type: "user",
      color: "text-[#8B1538]",
      bgColor: "bg-[#F5E6D3]/50"
    },
    { 
      id: 3,
      icon: FileText,
      title: "4 documents pending approval",
      time: "5 hours ago",
      type: "document",
      color: "text-[#D4AF37]",
      bgColor: "bg-[#F5E6D3]/30"
    },
    { 
      id: 4,
      icon: School,
      title: "Classroom A-102 scheduled for maintenance",
      time: "1 day ago",
      type: "classroom",
      color: "text-emerald-600",
      bgColor: "bg-emerald-100"
    },
  ];

  const quickActions = [
    { title: "Create Alert", icon: Bell, color: "bg-gradient-to-br from-[#8B1538] to-[#A01842]" },
    { title: "Add User", icon: Users, color: "bg-gradient-to-br from-[#D4AF37] to-[#B8941F]" },
    { title: "Upload Document", icon: FileText, color: "bg-gradient-to-br from-amber-500 to-amber-600" },
    { title: "Manage Rooms", icon: School, color: "bg-gradient-to-br from-emerald-500 to-emerald-600" },
  ];

  return (
    <div className="flex h-screen bg-gradient-to-br from-[#FFF9F0] via-[#F5E6D3] to-[#E8D5C4] overflow-hidden">
      <Sidebar isOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />
      
      <div className="flex-1 flex flex-col overflow-hidden">
        <Navbar onMenuClick={() => setSidebarOpen(true)} />
        
        <main className="flex-1 overflow-y-auto">
          <div className="p-8 space-y-8">
            {/* Header */}
            <div className="flex items-start justify-between">
              <div>
                <h1 className="text-4xl font-bold bg-gradient-to-r from-[#8B1538] to-[#A01842] bg-clip-text text-transparent">
                  Admin Dashboard
                </h1>
                <p className="text-[#8B1538]/70 mt-2 flex items-center gap-2">
                  <Activity className="w-4 h-4" />
                  Overview of campus activities
                </p>
              </div>
              <div className="flex items-center gap-3">
                <button className="px-4 py-2 bg-white rounded-lg shadow-sm hover:shadow-md transition-all text-[#8B1538] font-medium border border-[#8B1538]/20">
                  Export Report
                </button>
                <button className="px-4 py-2 bg-gradient-to-r from-[#8B1538] to-[#A01842] text-white rounded-lg shadow-md hover:shadow-lg transition-all font-medium">
                  New Action
                </button>
              </div>
            </div>

            {/* Stats Cards */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {stats.map((stat) => {
                const Icon = stat.icon;
                const isPositive = stat.trend === "up";
                const TrendIcon = isPositive ? ArrowUpRight : ArrowDownRight;
                
                return (
                  <div
                    key={stat.title}
                    className="bg-white rounded-2xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 border border-[#8B1538]/10 group hover:-translate-y-1"
                  >
                    <div className="flex items-start justify-between mb-4">
                      <div className={`p-3 rounded-xl ${stat.bgColor}`}>
                        <Icon className={`w-6 h-6 ${stat.textColor}`} />
                      </div>
                      <div className={`flex items-center gap-1 text-sm font-semibold ${isPositive ? 'text-emerald-600' : 'text-red-600'}`}>
                        <TrendIcon className="w-4 h-4" />
                        {stat.change}
                      </div>
                    </div>
                    <p className="text-sm text-[#8B1538]/60 font-medium">{stat.title}</p>
                    <h3 className="text-3xl font-bold text-[#8B1538] mt-1">{stat.value}</h3>
                  </div>
                );
              })}
            </div>

            {/* Two Column Layout */}
            <div className="grid lg:grid-cols-3 gap-6">
              {/* Recent Activity */}
              <div className="lg:col-span-2 bg-white rounded-2xl shadow-lg border border-[#8B1538]/10 overflow-hidden">
                <div className="p-6 border-b border-[#8B1538]/10 bg-gradient-to-r from-[#F5E6D3]/30 to-white">
                  <div className="flex items-center justify-between">
                    <h2 className="text-xl font-bold text-[#8B1538] flex items-center gap-2">
                      <Activity className="w-5 h-5 text-[#8B1538]" />
                      Recent Activity
                    </h2>
                    <button className="text-sm text-[#8B1538] hover:text-[#A01842] font-medium">
                      View All
                    </button>
                  </div>
                </div>
                <div className="p-6">
                  <ul className="space-y-4">
                    {recentActivity.map((activity) => {
                      const Icon = activity.icon;
                      return (
                        <li
                          key={activity.id}
                          className="flex items-start gap-4 p-4 rounded-xl hover:bg-[#F5E6D3]/20 transition-colors group cursor-pointer"
                        >
                          <div className={`p-2 rounded-lg ${activity.bgColor} group-hover:scale-110 transition-transform`}>
                            <Icon className={`w-5 h-5 ${activity.color}`} />
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-[#8B1538] font-medium group-hover:text-[#A01842] transition-colors">
                              {activity.title}
                            </p>
                            <p className="text-sm text-[#8B1538]/50 mt-1 flex items-center gap-1">
                              <Clock className="w-3 h-3" />
                              {activity.time}
                            </p>
                          </div>
                          <ArrowUpRight className="w-5 h-5 text-[#8B1538]/40 opacity-0 group-hover:opacity-100 transition-opacity" />
                        </li>
                      );
                    })}
                  </ul>
                </div>
              </div>

              {/* Quick Actions */}
              <div className="bg-white rounded-2xl shadow-lg border border-[#8B1538]/10 overflow-hidden">
                <div className="p-6 border-b border-[#8B1538]/10 bg-gradient-to-r from-[#F5E6D3]/30 to-white">
                  <h2 className="text-xl font-bold text-[#8B1538] flex items-center gap-2">
                    <TrendingUp className="w-5 h-5 text-[#8B1538]" />
                    Quick Actions
                  </h2>
                </div>
                <div className="p-6">
                  <div className="space-y-3">
                    {quickActions.map((action) => {
                      const Icon = action.icon;
                      return (
                        <button
                          key={action.title}
                          className="w-full flex items-center gap-4 p-4 rounded-xl hover:bg-[#F5E6D3]/20 transition-all group text-left border border-[#8B1538]/10 hover:border-[#8B1538]/20 hover:shadow-md"
                        >
                          <div className={`p-3 rounded-lg ${action.color} text-white group-hover:scale-110 transition-transform`}>
                            <Icon className="w-5 h-5" />
                          </div>
                          <span className="font-semibold text-[#8B1538]/80 group-hover:text-[#8B1538]">
                            {action.title}
                          </span>
                          <ArrowUpRight className="w-4 h-4 text-[#8B1538]/40 ml-auto opacity-0 group-hover:opacity-100 transition-opacity" />
                        </button>
                      );
                    })}
                  </div>
                </div>
              </div>
            </div>

            {/* System Status */}
            <div className="bg-gradient-to-r from-emerald-500 to-teal-600 rounded-2xl shadow-lg p-6 text-white">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-white/20 rounded-lg">
                    <CheckCircle className="w-6 h-6" />
                  </div>
                  <div>
                    <h3 className="font-bold text-lg">All Systems Operational</h3>
                    <p className="text-emerald-50 text-sm">Last checked: 2 minutes ago</p>
                  </div>
                </div>
                <button className="px-4 py-2 bg-white/20 hover:bg-white/30 rounded-lg font-medium transition-colors backdrop-blur-sm">
                  View Status
                </button>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}