"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabaseClient";
import { UserPlus, Trash2, ToggleLeft, ToggleRight, UserCog } from "lucide-react";

interface Student {
  id: string;           // uuid from DB
  roll_no: string;      // NOTE: matches DB column name
  name: string;
  branch?: string;
  email: string;
  status: "Active" | "Inactive";
}

interface Teacher {
  id: string;           // uuid from DB
  tid: string;          // matches DB column name
  name: string;
  branch?: string;
  email: string;
  status: "Active" | "Inactive";
}

export default function UsersPage() {
  const [students, setStudents] = useState<Student[]>([]);
  const [teachers, setTeachers] = useState<Teacher[]>([]);
  const [filter, setFilter] = useState<"Students" | "Teachers">("Students");
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(true);

  const [newUser, setNewUser] = useState({
    id: "",
    name: "",
    branch: "",
    email: "",
  });

  // Fetch data
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      const { data: studentData, error: studentError } = await supabase
        .from("students")
        .select("*")
        .order("name", { ascending: true });

      const { data: teacherData, error: teacherError } = await supabase
        .from("teachers")
        .select("*")
        .order("name", { ascending: true });

      if (studentError || teacherError) {
        console.error("Error fetching data:", JSON.stringify(studentError || teacherError));
      }

      setStudents((studentData || []) as Student[]);
      setTeachers((teacherData || []) as Teacher[]);
      setLoading(false);
    };

    fetchData();
  }, []);

  // Add new user (with correct column names and returning the inserted row)
  const handleAdd = async () => {
    if (!newUser.id || !newUser.name || !newUser.branch || !newUser.email) {
      alert("Please fill all fields");
      return;
    }

    try {
      if (filter === "Students") {
        const newStudentPayload = {
          roll_no: newUser.id, // <--- important: matches DB column `roll_no`
          name: newUser.name,
          branch: newUser.branch,
          email: newUser.email,
          status: "Active",
        };

        const { data, error, status } = await supabase
          .from("students")
          .insert([newStudentPayload])
          .select() // returns the inserted row(s)
          .single(); // convenience to get single row

        console.log("Insert student status:", status, "data:", data, "error:", JSON.stringify(error));

        if (error) {
          alert("Failed to add student — check console for details");
          return;
        }

        // data contains the real row (with uuid)
        setStudents((prev) => [data as Student, ...prev]);
      } else {
        const newTeacherPayload = {
          tid: newUser.id, // <--- matches DB column `tid`
          name: newUser.name,
          branch: newUser.branch,
          email: newUser.email,
          status: "Active",
        };

        const { data, error, status } = await supabase
          .from("teachers")
          .insert([newTeacherPayload])
          .select()
          .single();

        console.log("Insert teacher status:", status, "data:", data, "error:", JSON.stringify(error));

        if (error) {
          alert("Failed to add teacher — check console for details");
          return;
        }

        setTeachers((prev) => [data as Teacher, ...prev]);
      }

      setNewUser({ id: "", name: "", branch: "", email: "" });
      setShowModal(false);
    } catch (err) {
      console.error("Unexpected error on add:", err);
      alert("Unexpected error — check console");
    }
  };

  // Delete record by uuid id
  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure?")) return;
    try {
      if (filter === "Students") {
        const { error } = await supabase.from("students").delete().eq("id", id);
        if (error) {
          console.error("Delete student error:", JSON.stringify(error));
          alert("Failed to delete student");
          return;
        }
        setStudents((prev) => prev.filter((s) => s.id !== id));
      } else {
        const { error } = await supabase.from("teachers").delete().eq("id", id);
        if (error) {
          console.error("Delete teacher error:", JSON.stringify(error));
          alert("Failed to delete teacher");
          return;
        }
        setTeachers((prev) => prev.filter((t) => t.id !== id));
      }
    } catch (err) {
      console.error("Unexpected delete error:", err);
      alert("Unexpected error — check console");
    }
  };

  // Toggle Active/Inactive by uuid id
  const toggleStatus = async (id: string, currentStatus: string) => {
    const newStatus = currentStatus === "Active" ? "Inactive" : "Active";
    try {
      if (filter === "Students") {
        const { data, error } = await supabase
          .from("students")
          .update({ status: newStatus })
          .eq("id", id)
          .select()
          .single();

        if (error) {
          console.error("Toggle student status error:", JSON.stringify(error));
          alert("Failed to update status");
          return;
        }

        setStudents((prev) => prev.map((s) => (s.id === id ? (data as Student) : s)));
      } else {
        const { data, error } = await supabase
          .from("teachers")
          .update({ status: newStatus })
          .eq("id", id)
          .select()
          .single();

        if (error) {
          console.error("Toggle teacher status error:", JSON.stringify(error));
          alert("Failed to update status");
          return;
        }

        setTeachers((prev) => prev.map((t) => (t.id === id ? (data as Teacher) : t)));
      }
    } catch (err) {
      console.error("Unexpected toggle error:", err);
      alert("Unexpected error — check console");
    }
  };

  if (loading) return <p className="p-6 text-gray-500">Loading...</p>;

  return (
    <div className="p-6 bg-[#fdf8f6] min-h-screen">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-[#7c183d] flex items-center gap-2">
          <UserCog className="w-6 h-6" /> User Management
        </h1>
        <button
          onClick={() => setShowModal(true)}
          className="flex items-center gap-2 px-4 py-2 bg-[#7c183d] text-white rounded-md hover:bg-[#61122e]"
        >
          <UserPlus className="w-5 h-5" /> Add {filter.slice(0, -1)}
        </button>
      </div>

      {/* Filter Tabs */}
      <div className="flex gap-4 mb-6">
        {["Students", "Teachers"].map((type) => (
          <button
            key={type}
            onClick={() => setFilter(type as "Students" | "Teachers")}
            className={`px-4 py-2 rounded-md font-medium ${
              filter === type ? "bg-[#7c183d] text-white" : "bg-gray-200 text-gray-700 hover:bg-gray-300"
            }`}
          >
            {type}
          </button>
        ))}
      </div>

      {/* Table */}
      <div className="bg-white rounded-xl shadow overflow-hidden">
        <table className="w-full">
          <thead>
            <tr className="bg-[#F5E6D3]/70 border-b border-[#8B1538]/20">
              {filter === "Students" ? (
                <>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Roll No</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Name</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Branch</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Email</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Status</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Actions</th>
                </>
              ) : (
                <>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Teacher ID</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Name</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Branch</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Email</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Status</th>
                  <th className="py-3 px-4 text-[#8B1538] font-semibold">Actions</th>
                </>
              )}
            </tr>
          </thead>

          <tbody>
            {filter === "Students"
              ? students.map((s) => (
                  <tr key={s.id} className="border-b hover:bg-[#F5E6D3]/40 transition">
                    <td className="py-3 px-4 text-[#2C1810] font-medium">{s.roll_no}</td>
                    <td className="py-3 px-4 text-[#2C1810] font-medium">{s.name}</td>
                    <td className="py-3 px-4 text-[#2C1810]">{s.branch}</td>
                    <td className="py-3 px-4 text-[#2C1810]">{s.email}</td>
                    <td className="py-3 px-4">
                      <span className={`px-3 py-1 rounded-full text-xs font-medium ${s.status === "Active" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}`}>
                        {s.status}
                      </span>
                    </td> 
                    <td className="py-3 px-4 flex items-center gap-3">
                      <button onClick={() => toggleStatus(s.id, s.status)} className="text-gray-700 hover:text-[#7c183d]">
                        {s.status === "Active" ? <ToggleRight className="w-5 h-5 text-green-600" /> : <ToggleLeft className="w-5 h-5 text-gray-400" />}
                      </button>
                      <button onClick={() => handleDelete(s.id)} className="text-red-600 hover:underline">
                        <Trash2 className="w-5 h-5" />
                      </button>
                    </td>
                  </tr>
                ))
              : teachers.map((t) => (
                  <tr key={t.id} className="border-b hover:bg-[#F5E6D3]/40 transition">
                    <td className="py-3 px-4 text-[#2C1810] font-medium">{t.tid}</td>
                    <td className="py-3 px-4 text-[#2C1810] font-medium">{t.name}</td>
                    <td className="py-3 px-4 text-[#2C1810]">{t.branch}</td>
                    <td className="py-3 px-4 text-[#2C1810]">{t.email}</td>
                    <td className="py-3 px-4">
                      <span className={`px-3 py-1 rounded-full text-xs font-medium ${t.status === "Active" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}`}>
                        {t.status}
                      </span>
                    </td>
                    <td className="py-3 px-4 flex items-center gap-3">
                      <button onClick={() => toggleStatus(t.id, t.status)} className="text-gray-700 hover:text-[#7c183d]">
                        {t.status === "Active" ? <ToggleRight className="w-5 h-5 text-green-600" /> : <ToggleLeft className="w-5 h-5 text-gray-400" />}
                      </button>
                      <button onClick={() => handleDelete(t.id)} className="text-red-600 hover:underline">
                        <Trash2 className="w-5 h-5" />
                      </button>
                    </td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>

      {/* Add User Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-lg p-6 w-[90%] sm:w-[400px] relative">
            <button onClick={() => setShowModal(false)} className="absolute top-3 right-3 text-gray-500 hover:text-gray-700">✖</button>

            <h2 className="text-xl font-bold mb-4 text-[#7c183d]">Add New {filter === "Students" ? "Student" : "Teacher"}</h2>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700">{filter === "Students" ? "Roll Number" : "Teacher ID"}</label>
                <input type="text" value={newUser.id} onChange={(e) => setNewUser({ ...newUser, id: e.target.value })} className="w-full border rounded-md px-3 py-2 focus:ring-2 focus:ring-[#7c183d]" />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Name</label>
                <input type="text" value={newUser.name} onChange={(e) => setNewUser({ ...newUser, name: e.target.value })} className="w-full border rounded-md px-3 py-2 focus:ring-2 focus:ring-[#7c183d]" />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Branch</label>
                <input type="text" value={newUser.branch} onChange={(e) => setNewUser({ ...newUser, branch: e.target.value })} className="w-full border rounded-md px-3 py-2 focus:ring-2 focus:ring-[#7c183d]" />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Email</label>
                <input type="email" value={newUser.email} onChange={(e) => setNewUser({ ...newUser, email: e.target.value })} className="w-full border rounded-md px-3 py-2 focus:ring-2 focus:ring-[#7c183d]" />
              </div>

              <div className="flex justify-end gap-3">
                <button onClick={() => setShowModal(false)} className="px-4 py-2 border rounded-md hover:bg-gray-100">Cancel</button>
                <button onClick={handleAdd} className="px-4 py-2 bg-[#7c183d] text-white rounded-md hover:bg-[#61122e]">Add</button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
