"use client";

import { useEffect, useState } from "react";
import { UserCog, Edit3, Save, Camera } from "lucide-react";
import { supabaseBrowser } from "@/lib/supabase-browser";
import { useSupabase } from "@/components/supabase-provider";

export default function AdminProfilePage() {
  const { session } = useSupabase();
  const supabase = supabaseBrowser;
  const [editMode, setEditMode] = useState(false);
  const [loading, setLoading] = useState(true);

  const [profile, setProfile] = useState<any>({
    name: "",
    email: "",
    office_name: "",
    department: "",
    campus: "",
    phone: "",
    role: "",
    profile_url: "/default-avatar.png",
    created_at: "",
  });

  // Fetch admin data based on logged-in email
  const fetchAdmin = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from("admins")
      .select("*")
      .eq("email", session?.user?.email)
      .single();

    if (!error && data) setProfile(data);
    setLoading(false);
  };

  useEffect(() => {
    if (session?.user?.email) fetchAdmin();
  }, [session]);

  // Handle profile update
  const handleSave = async () => {
    try {
      const { error } = await supabase
        .from("admins")
        .update({
          name: profile.name,
          office_name: profile.office_name,
          department: profile.department,
          campus: profile.campus,
          phone: profile.phone,
          profile_url: profile.profile_url,
        })
        .eq("email", session?.user?.email);

      if (error) throw error;
      alert("✅ Profile updated successfully!");
      setEditMode(false);
    } catch (err: any) {
      console.error(err.message);
      alert("❌ Failed to update profile.");
    }
  };

  // Handle field changes
  const handleChange = (field: string, value: string) => {
    setProfile((prev: any) => ({ ...prev, [field]: value }));
  };

  // Handle image upload
  const handleImageChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const fileName = `${Date.now()}-${file.name}`;
    const { error: uploadError } = await supabase.storage
      .from("admin-profiles")
      .upload(fileName, file);

    if (uploadError) {
      console.error(uploadError.message);
      alert("❌ Image upload failed.");
      return;
    }

    const {
      data: { publicUrl },
    } = supabase.storage.from("admin-profiles").getPublicUrl(fileName);

    setProfile((prev: any) => ({ ...prev, profile_url: publicUrl }));
    alert("✅ Profile picture updated!");
  };

  if (loading)
    return (
      <div className="p-8 text-center text-gray-500">Loading profile...</div>
    );

  return (
    <div className="p-6 bg-[#fdf8f6] min-h-screen">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-[#7c183d] flex items-center gap-2">
          <UserCog className="w-6 h-6" /> Admin Profile
        </h1>
        <button
          onClick={() => (editMode ? handleSave() : setEditMode(true))}
          className={`flex items-center gap-2 px-4 py-2 rounded-md ${
            editMode
              ? "bg-green-600 text-white hover:bg-green-700"
              : "bg-[#7c183d] text-white hover:bg-[#61122e]"
          }`}
        >
          {editMode ? <Save className="w-5 h-5" /> : <Edit3 className="w-5 h-5" />}
          {editMode ? "Save Changes" : "Edit Profile"}
        </button>
      </div>

      {/* Profile Card */}
      <div className="bg-white rounded-xl shadow-lg p-6 flex flex-col sm:flex-row items-center sm:items-start gap-8">
        {/* Profile Image */}
        <div className="relative">
          <img
            src={profile.profile_url || "/default-avatar.png"}
            alt="Profile"
            className="w-40 h-40 rounded-full object-cover border-4 border-[#7c183d]"
          />
          {editMode && (
            <>
              <label
                htmlFor="profile-photo"
                className="absolute bottom-2 right-2 bg-[#7c183d] p-2 rounded-full text-white cursor-pointer hover:bg-[#61122e]"
              >
                <Camera className="w-4 h-4" />
              </label>
              <input
                type="file"
                id="profile-photo"
                accept="image/*"
                className="hidden"
                onChange={handleImageChange}
              />
            </>
          )}
        </div>

        {/* Profile Info */}
        <div className="flex-1 space-y-4 w-full">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-600">
                Office Name
              </label>
              <input
                type="text"
                value={profile.office_name || ""}
                disabled={!editMode}
                onChange={(e) => handleChange("office_name", e.target.value)}
                className={`w-full border rounded-md px-3 py-2 ${
                  editMode
                    ? "focus:ring-2 focus:ring-[#7c183d]"
                    : "bg-gray-100 text-gray-600 cursor-not-allowed"
                }`}
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-600">
                Department
              </label>
              <input
                type="text"
                value={profile.department || ""}
                disabled={!editMode}
                onChange={(e) => handleChange("department", e.target.value)}
                className={`w-full border rounded-md px-3 py-2 ${
                  editMode
                    ? "focus:ring-2 focus:ring-[#7c183d]"
                    : "bg-gray-100 text-gray-600 cursor-not-allowed"
                }`}
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-600">Campus</label>
            <input
              type="text"
              value={profile.campus || ""}
              disabled={!editMode}
              onChange={(e) => handleChange("campus", e.target.value)}
              className={`w-full border rounded-md px-3 py-2 ${
                editMode
                  ? "focus:ring-2 focus:ring-[#7c183d]"
                  : "bg-gray-100 text-gray-600 cursor-not-allowed"
              }`}
            />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-600">
                Admin Name
              </label>
              <input
                type="text"
                value={profile.name || ""}
                disabled={!editMode}
                onChange={(e) => handleChange("name", e.target.value)}
                className={`w-full border rounded-md px-3 py-2 ${
                  editMode
                    ? "focus:ring-2 focus:ring-[#7c183d]"
                    : "bg-gray-100 text-gray-600 cursor-not-allowed"
                }`}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-600">Email</label>
              <input
                type="email"
                value={profile.email || ""}
                disabled
                className="w-full border rounded-md px-3 py-2 bg-gray-100 text-gray-600 cursor-not-allowed"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-600">
                Contact Number
              </label>
              <input
                type="text"
                value={profile.phone || ""}
                disabled={!editMode}
                onChange={(e) => handleChange("phone", e.target.value)}
                className={`w-full border rounded-md px-3 py-2 ${
                  editMode
                    ? "focus:ring-2 focus:ring-[#7c183d]"
                    : "bg-gray-100 text-gray-600 cursor-not-allowed"
                }`}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-600">
                Role
              </label>
              <input
                type="text"
                value={profile.role || "Department Admin"}
                disabled
                className="w-full border rounded-md px-3 py-2 bg-gray-100 text-gray-600 cursor-not-allowed"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
