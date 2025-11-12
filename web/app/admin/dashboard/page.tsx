"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import {
  TrendingUp,
  Users,
  AlertCircle,
  FileText,
  School,
  Activity,
  ArrowUpRight,
  Bell,
  CheckCircle,
  Clock,
  ClipboardList,
} from "lucide-react";
import { supabaseBrowser } from "@/lib/supabase-browser";

export default function AdminDashboard() {
  const supabase = supabaseBrowser;
  const router = useRouter();

  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    users: 0,
    alerts: 0,
    pending: 0,
    classrooms: 0,
  });
  const [recentActivity, setRecentActivity] = useState<any[]>([]);

  // Fetch dashboard data
  const fetchDashboardData = async () => {
    setLoading(true);

    try {
      const { count: teacherCount } = await supabase
        .from("teachers")
        .select("*", { count: "exact", head: true });

      const { count: studentCount } = await supabase
        .from("students")
        .select("*", { count: "exact", head: true });

      const { count: alertCount } = await supabase
        .from("alerts")
        .select("*", { count: "exact", head: true });

      const { count: pendingCount } = await supabase
        .from("bookings")
        .select("*", { count: "exact", head: true })
        .eq("status", "Pending");

      const { count: roomCount } = await supabase
        .from("classrooms")
        .select("*", { count: "exact", head: true });

      const { data: alertData } = await supabase
        .from("alerts")
        .select("title, created_at")
        .order("created_at", { ascending: false })
        .limit(3);

      const { data: bookingData } = await supabase
        .from("bookings")
        .select("room, purpose, status, created_at")
        .order("created_at", { ascending: false })
        .limit(2);

      const combinedActivity = [
        ...(alertData || []).map((a: any) => ({
          title: `New alert posted: ${a.title}`,
          time: new Date(a.created_at).toLocaleString(),
          icon: Bell,
          color: "text-[#8B1538]",
          bgColor: "bg-[#F5E6D3]/50",
        })),
        ...(bookingData || []).map((b: any) => ({
          title: `Booking request: ${b.room} — ${b.purpose}`,
          time: new Date(b.created_at).toLocaleString(),
          icon: ClipboardList,
          color: "text-amber-600",
          bgColor: "bg-amber-100",
        })),
      ];

      setStats({
        users: (teacherCount || 0) + (studentCount || 0),
        alerts: alertCount || 0,
        pending: pendingCount || 0,
        classrooms: roomCount || 0,
      });
      setRecentActivity(combinedActivity);
    } catch (error) {
      console.error("Dashboard fetch error:", error);
    }

    setLoading(false);
  };

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const statCards = [
    {
      title: "Total Users",
      value: stats.users,
      icon: Users,
      bgColor: "bg-[#F5E6D3]/50",
      textColor: "text-[#8B1538]",
    },
    {
      title: "Active Alerts",
      value: stats.alerts,
      icon: AlertCircle,
      bgColor: "bg-red-50",
      textColor: "text-red-600",
    },
    {
      title: "Pending Requests",
      value: stats.pending,
      icon: ClipboardList,
      bgColor: "bg-amber-50",
      textColor: "text-amber-600",
    },
    {
      title: "Classrooms",
      value: stats.classrooms,
      icon: School,
      bgColor: "bg-emerald-50",
      textColor: "text-emerald-600",
    },
  ];

  const quickActions = [
    { title: "Create Alert", icon: Bell, color: "bg-gradient-to-br from-[#8B1538] to-[#A01842]", path: "/admin/alerts" },
    { title: "Add User", icon: Users, color: "bg-gradient-to-br from-[#D4AF37] to-[#B8941F]", path: "/admin/users" },
    { title: "Manage Requests", icon: ClipboardList, color: "bg-gradient-to-br from-amber-500 to-amber-600", path: "/admin/classrooms" },
    { title: "Manage Rooms", icon: School, color: "bg-gradient-to-br from-emerald-500 to-emerald-600", path: "/admin/classrooms" },
  ];

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <h1 className="text-4xl font-bold bg-gradient-to-r from-[#8B1538] to-[#A01842] bg-clip-text text-transparent">
            Admin Dashboard
          </h1>
          <p className="text-[#8B1538]/70 mt-2 flex items-center gap-2">
            <Activity className="w-4 h-4" />
            Real-time overview of campus activities
          </p>
        </div>
        <div className="flex items-center gap-3">
          <button
            onClick={() => fetchDashboardData()}
            className="px-4 py-2 bg-white rounded-lg shadow-sm hover:shadow-md transition-all text-[#8B1538] font-medium border border-[#8B1538]/20"
          >
            Refresh
          </button>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {loading ? (
          <p className="text-gray-500">Loading stats...</p>
        ) : (
          statCards.map((stat) => {
            const Icon = stat.icon;
            return (
              <div
                key={stat.title}
                className="bg-white rounded-2xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 border border-[#8B1538]/10 group hover:-translate-y-1"
              >
                <div className="flex items-start justify-between mb-4">
                  <div className={`p-3 rounded-xl ${stat.bgColor}`}>
                    <Icon className={`w-6 h-6 ${stat.textColor}`} />
                  </div>
                </div>
                <p className="text-sm text-[#8B1538]/60 font-medium">
                  {stat.title}
                </p>
                <h3 className="text-3xl font-bold text-[#8B1538] mt-1">
                  {stat.value}
                </h3>
              </div>
            );
          })
        )}
      </div>

      {/* Two Column Layout */}
      <div className="grid lg:grid-cols-3 gap-6">
        {/* Recent Activity */}
        <div className="lg:col-span-2 bg-white rounded-2xl shadow-lg border border-[#8B1538]/10 overflow-hidden">
          <div className="p-6 border-b border-[#8B1538]/10 bg-gradient-to-r from-[#F5E6D3]/30 to-white">
            <h2 className="text-xl font-bold text-[#8B1538] flex items-center gap-2">
              <Activity className="w-5 h-5 text-[#8B1538]" />
              Recent Activity
            </h2>
          </div>
          <div className="p-6">
            {recentActivity.length === 0 ? (
              <p className="text-gray-500 text-sm">No recent activity found.</p>
            ) : (
              <ul className="space-y-4">
                {recentActivity.map((activity, idx) => {
                  const Icon = activity.icon;
                  return (
                    <li
                      key={idx}
                      className="flex items-start gap-4 p-4 rounded-xl hover:bg-[#F5E6D3]/20 transition-colors group cursor-pointer"
                    >
                      <div
                        className={`p-2 rounded-lg ${activity.bgColor} group-hover:scale-110 transition-transform`}
                      >
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
            )}
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
          <div className="p-6 space-y-3">
            {quickActions.map((action) => {
              const Icon = action.icon;
              return (
                <button
                  key={action.title}
                  onClick={() => router.push(action.path)}
                  className="w-full flex items-center gap-4 p-4 rounded-xl hover:bg-[#F5E6D3]/20 transition-all group text-left border border-[#8B1538]/10 hover:border-[#8B1538]/20 hover:shadow-md"
                >
                  <div
                    className={`p-3 rounded-lg ${action.color} text-white group-hover:scale-110 transition-transform`}
                  >
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

      {/* System Status */}
      <div className="bg-gradient-to-r from-emerald-500 to-teal-600 rounded-2xl shadow-lg p-6 text-white">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-white/20 rounded-lg">
              <CheckCircle className="w-6 h-6" />
            </div>
            <div>
              <h3 className="font-bold text-lg">All Systems Operational</h3>
              <p className="text-emerald-50 text-sm">
                Last checked: {new Date().toLocaleTimeString()}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
