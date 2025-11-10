"use client";

export default function Navbar() {
  return (
    <header className="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-6 shadow-sm">
      <h1 className="text-xl font-semibold text-gray-800">Admin Dashboard</h1>
      <div className="flex items-center gap-4">
        <button className="text-sm text-gray-600 hover:text-gray-900">
          Notifications
        </button>
        <button className="text-sm text-gray-600 hover:text-gray-900">
          Logout
        </button>
      </div>
    </header>
  );
}
