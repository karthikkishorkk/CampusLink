"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";

const navItems = [
  { name: "Dashboard", href: "/admin/dashboard" },
  { name: "Alerts & Circulars", href: "/admin/alerts" },
  { name: "Documents", href: "/admin/documents" },
  { name: "Classrooms", href: "/admin/classrooms" },
  { name: "Bookings", href: "/admin/bookings" },
  { name: "Users", href: "/admin/users" },
  { name: "Profile", href: "/admin/profile" },
  { name: "Settings", href: "/admin/settings" },
];


export default function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="w-64 h-screen bg-gray-900 text-white flex flex-col">
      <div className="p-6 text-2xl font-bold border-b border-gray-700">
        CampusLink
      </div>
      <nav className="flex-1 p-4 space-y-2">
        {navItems.map((item) => (
          <Link
            key={item.name}
            href={item.href}
            className={`block px-4 py-2 rounded-md transition ${
              pathname === item.href
                ? "bg-gray-700 text-white"
                : "text-gray-300 hover:bg-gray-800"
            }`}
          >
            {item.name}
          </Link>
        ))}
      </nav>
    </aside>
  );
}
