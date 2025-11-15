"use client";

import { useEffect, useState } from "react";
import { CalendarDays, CheckCircle, XCircle } from "lucide-react";
import { supabaseBrowser } from "@/lib/supabase-browser";

export default function BookingRequestsPage() {
  const supabase = supabaseBrowser;
  const [bookings, setBookings] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  // Fetch all bookings
  const fetchBookings = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from("bookings")
      .select("id, teacher_id, room, date, time_slot, purpose, status, created_at");
    if (!error && data) setBookings(data);
    setLoading(false);
  };

  useEffect(() => {
    fetchBookings();
  }, []);

  // Approve booking
  const handleApprove = async (id: string, room: string) => {
    try {
      const { error } = await supabase
        .from("bookings")
        .update({ status: "Approved" })
        .eq("id", id);

      if (error) throw error;

      // Update classroom status
      await supabase.from("classrooms").update({ status: "Occupied" }).eq("room_no", room);

      alert("✅ Booking approved!");
      fetchBookings();
    } catch (error: any) {
      console.error("Approve failed:", error.message);
      alert("❌ Failed to approve booking.");
    }
  };

  // Reject booking (INSTANT — NO MODAL)
  const handleReject = async (id: string) => {
    try {
      const { error } = await supabase
        .from("bookings")
        .update({ status: "Rejected" })
        .eq("id", id);

      if (error) throw error;

      alert("❌ Booking rejected!");
      fetchBookings();
    } catch (error: any) {
      console.error("Reject failed:", error.message);
      alert("❌ Failed to reject booking.");
    }
  };

  return (
    <div className="p-8">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-3xl font-bold text-[#8B1538] flex items-center gap-2">
          <CalendarDays className="w-7 h-7" /> Booking Requests
        </h1>
      </div>

      {loading ? (
        <p className="text-gray-500 text-center py-10">Loading booking requests...</p>
      ) : bookings.length === 0 ? (
        <p className="text-gray-500 text-center py-10">No booking requests found.</p>
      ) : (
        <div className="bg-white border border-[#8B1538]/20 rounded-xl shadow-sm overflow-hidden">
          <table className="w-full border-collapse">
            <thead className="bg-[#F5E6D3]/70">
              <tr>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Room</th>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Date</th>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Time Slot</th>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Purpose</th>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Status</th>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Actions</th>
              </tr>
            </thead>
            <tbody>
              {bookings.map((booking) => (
                <tr
                  key={booking.id}
                  className="border-b hover:bg-[#F5E6D3]/40 transition"
                >
                  <td className="py-3 px-4 text-[#2C1810]">{booking.room}</td>
                  <td className="py-3 px-4 text-[#2C1810]">
                    {new Date(booking.date).toLocaleDateString()}
                  </td>
                  <td className="py-3 px-4 text-[#2C1810]">{booking.time_slot}</td>
                  <td className="py-3 px-4 text-[#2C1810]">{booking.purpose}</td>
                  <td className="py-3 px-4">
                    <span
                      className={`px-3 py-1 rounded-full text-xs font-medium ${
                        booking.status === "Approved"
                          ? "bg-green-100 text-green-700"
                          : booking.status === "Rejected"
                          ? "bg-red-100 text-red-700"
                          : "bg-yellow-100 text-yellow-700"
                      }`}
                    >
                      {booking.status}
                    </span>
                  </td>
                  <td className="py-3 px-4 flex items-center gap-3">
                    {booking.status === "Pending" && (
                      <>
                        <button
                          onClick={() => handleApprove(booking.id, booking.room)}
                          className="flex items-center gap-1 text-green-700 hover:underline font-medium"
                        >
                          <CheckCircle className="w-4 h-4" /> Approve
                        </button>
                        <button
                          onClick={() => handleReject(booking.id)}
                          className="flex items-center gap-1 text-red-700 hover:underline font-medium"
                        >
                          <XCircle className="w-4 h-4" /> Reject
                        </button>
                      </>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
