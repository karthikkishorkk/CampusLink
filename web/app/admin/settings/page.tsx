"use client";

import { useState } from "react";
import { Settings, Bell, Sun, Moon, LogOut, KeyRound } from "lucide-react";

export default function SettingsPage() {
  const [darkMode, setDarkMode] = useState(false);
  const [emailNotifs, setEmailNotifs] = useState(true);
  const [inAppNotifs, setInAppNotifs] = useState(true);

  return (
    <div className="p-6 bg-[#fdf8f6] min-h-screen">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-[#7c183d] flex items-center gap-2">
          <Settings className="w-6 h-6" /> Settings
        </h1>
      </div>

      {/* Settings Card */}
      <div className="bg-white rounded-xl shadow-md p-6 space-y-8">
        {/* General Preferences */}
        <section>
          <h2 className="text-lg font-semibold text-[#7c183d] mb-4">
            General Preferences
          </h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-[#2C1810]">
                Office / Department
              </label>
              <input
                type="text"
                value="CSE Office - Coimbatore Campus"
                disabled
                className="w-full mt-1 border border-gray-300 rounded-md px-3 py-2 bg-gray-100 cursor-not-allowed text-[#2C1810] font-medium"
              />
            </div>

            <div className="flex items-center justify-between border p-3 rounded-md">
              <div className="flex items-center gap-2">
                {darkMode ? <Moon className="w-5 h-5 text-gray-600" /> : <Sun className="w-5 h-5 text-gray-600" />}
                <span className="font-medium text-[#2C1810]">Dark Mode</span>
              </div>
              <button
                onClick={() => setDarkMode(!darkMode)}
                className={`relative inline-flex h-6 w-11 items-center rounded-full transition ${
                  darkMode ? "bg-[#7c183d]" : "bg-gray-300"
                }`}
              >
                <span
                  className={`inline-block h-4 w-4 transform rounded-full bg-white transition ${
                    darkMode ? "translate-x-6" : "translate-x-1"
                  }`}
                />
              </button>
            </div>
          </div>
        </section>

        {/* Notifications */}
        <section>
          <h2 className="text-lg font-semibold text-[#7c183d] mb-4 flex items-center gap-2">
            <Bell className="w-5 h-5" /> Notification Preferences
          </h2>
          <div className="space-y-3">
            <div className="flex items-center justify-between border p-3 rounded-md">
              <span className="text-[#2C1810] font-medium">Email Notifications</span>
              <button
                onClick={() => setEmailNotifs(!emailNotifs)}
                className={`relative inline-flex h-6 w-11 items-center rounded-full transition ${
                  emailNotifs ? "bg-[#7c183d]" : "bg-gray-300"
                }`}
              >
                <span
                  className={`inline-block h-4 w-4 transform rounded-full bg-white transition ${
                    emailNotifs ? "translate-x-6" : "translate-x-1"
                  }`}
                />
              </button>
            </div>

            <div className="flex items-center justify-between border p-3 rounded-md">
              <span className="text-[#2C1810] font-medium">In-App Alerts</span>
              <button
                onClick={() => setInAppNotifs(!inAppNotifs)}
                className={`relative inline-flex h-6 w-11 items-center rounded-full transition ${
                  inAppNotifs ? "bg-[#7c183d]" : "bg-gray-300"
                }`}
              >
                <span
                  className={`inline-block h-4 w-4 transform rounded-full bg-white transition ${
                    inAppNotifs ? "translate-x-6" : "translate-x-1"
                  }`}
                />
              </button>
            </div>
          </div>
        </section>

        {/* Account Settings */}
        <section>
          <h2 className="text-lg font-semibold text-[#7c183d] mb-4">
            Account Settings
          </h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-[#2C1810]">
                Admin Name
              </label>
              <input
                type="text"
                value="Dr. Karthik Kishor"
                disabled
                className="w-full mt-1 border border-gray-300 rounded-md px-3 py-2 bg-gray-100 cursor-not-allowed text-[#2C1810] font-medium"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-[#2C1810]">
                Admin Email
              </label>
              <input
                type="email"
                value="cseoffice@amrita.edu"
                disabled
                className="w-full mt-1 border border-gray-300 rounded-md px-3 py-2 bg-gray-100 cursor-not-allowed text-[#2C1810] font-medium"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-[#2C1810]">
                Role
              </label>
              <input
                type="text"
                value="Department Admin"
                disabled
                className="w-full mt-1 border border-gray-300 rounded-md px-3 py-2 bg-gray-100 cursor-not-allowed text-[#2C1810] font-medium"
              />
            </div>

            <div className="flex items-center justify-between border p-3 rounded-md">
              <div className="flex items-center gap-2">
                <KeyRound className="w-5 h-5 text-gray-600" />
                <span className="text-[#2C1810] font-medium">Change Password</span>
              </div>
              <button className="text-[#7c183d] hover:underline font-medium">Change</button>
            </div>

            <div className="flex justify-end">
              <button className="flex items-center gap-2 px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 font-medium">
                <LogOut className="w-4 h-4" /> Logout
              </button>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}
